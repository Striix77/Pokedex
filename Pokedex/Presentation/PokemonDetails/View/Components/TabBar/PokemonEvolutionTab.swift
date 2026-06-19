//
//  PokemonEvolutionTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonEvolutionTab: View {
    @State private var viewModel = PokemonEvolutionViewModel(
        useCase: PokemonEvolutionChainUseCase(
            apiService: PokemonEvolutionChainAPIService()
        )
    )
    @Environment(\.dismiss) var dismiss
    @State private var selectedPokemonName: String?

    let pokemonName: String
    let types: [PokemonType]
    let accentColor: Color

    private var pokemonNameForFetching: String {
        pokemonName.replacing(/-mega.*/, with: "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.outerSpacing) {
            if let chain = viewModel.evolutionChain {
                evolutionSpeciesSection(for: chain)

                if let megaPokemon = chain.pokemonSpecies.last?.megaPokemon, !megaPokemon.isEmpty {
                    megaEvolutionSection(megaPokemon)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(duration: Constants.selectionAnimationDuration)) {
                selectedPokemonName = nil
            }
        }
        .navigationDestination(for: PokemonListEntry.self) { entry in
            PokemonDetailsView(pokemonListEntry: entry, types: types)
        }
        .task { await viewModel.fetchEvolutionChain(pokemonName: pokemonNameForFetching) }
        .fetchingAlert(
            showAlert: $viewModel.showAlert,
            fetchAction: { await viewModel.fetchEvolutionChain(pokemonName: pokemonNameForFetching) },
            confirmAction: { dismiss() },
            errorMessage: viewModel.errorMessage
        )
    }

    @ViewBuilder
    private func evolutionSpeciesSection(for chain: EvolutionChainEntry) -> some View {
        let count = chain.pokemonSpecies.count
        if count > Constants.radialLayoutThreshold {
            radialEvolutionSection(for: chain)
                .frame(maxWidth: .infinity, alignment: .center)
        } else if count > 1 {
            VStack(alignment: .center, spacing: Constants.innerSpacing) {
                ForEach(chain.pokemonSpecies) { species in
                    if let pokemon = species.defaultPokemon.first {
                        if species != chain.pokemonSpecies.first {
                            conditionBadge(for: species, pokemon: pokemon)
                        } else {
                            conditionBadge(pokemon: pokemon)
                        }
                        pokemonCard(species: species, pokemon: pokemon)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        } else {
            if let species = chain.pokemonSpecies.first, let pokemon = species.defaultPokemon.first {
                noEvolutionView(species: species, pokemon: pokemon)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
    }

    private func noEvolutionView(species: EvolutionSpecies, pokemon: EvolutionPokemon) -> some View {
        VStack(spacing: Constants.innerSpacing) {
            pokemonCard(species: species, pokemon: pokemon)
                .overlay(noEvolutionRingOverlay)
                .padding(.vertical, Constants.noEvolutionCardVerticalPadding)

            Text("\(pokemon.formattedName) \(Constants.noEvolutionText)")
                .foregroundStyle(.secondary)
                .font(.default)
                .multilineTextAlignment(.center)
        }
    }

    private var noEvolutionRingOverlay: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(accentColor, lineWidth: Constants.noEvolutionRingLineWidth)
                .scaleEffect(Constants.noEvolutionRingOneScale)
                .opacity(Constants.noEvolutionRingOneOpacity)
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(accentColor, lineWidth: Constants.noEvolutionRingLineWidth)
                .scaleEffect(Constants.noEvolutionRingTwoScale)
                .opacity(Constants.noEvolutionRingTwoOpacity)
        }
    }

    private func radialEvolutionSection(for chain: EvolutionChainEntry) -> some View {
        let evolutions = Array(chain.pokemonSpecies.dropFirst())
        let count = evolutions.count
        let baseSpecies = chain.pokemonSpecies.first
        let basePokemon = baseSpecies?.defaultPokemon.first
        let isBaseSelected = selectedPokemonName != nil && basePokemon?.formattedName == selectedPokemonName
        let selectedSpecies = evolutions.first(where: { $0.defaultPokemon.first?.formattedName == selectedPokemonName })

        return VStack(spacing: Constants.innerSpacing) {
            ZStack {
                if let base = baseSpecies, let pokemon = basePokemon {
                    pokemonCard(species: base, pokemon: pokemon)
                }

                ForEach(evolutions.indices, id: \.self) { index in
                    radialEvolutionEntry(for: evolutions[index], at: index, outOf: count)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: Constants.radialContainerSize)

            if let species = selectedSpecies, let pokemon = species.defaultPokemon.first {
                conditionBadge(for: species, pokemon: pokemon)
            } else if isBaseSelected, let pokemon = basePokemon {
                conditionBadge(pokemon: pokemon)
            }
        }
    }

    @ViewBuilder
    private func radialEvolutionEntry(for species: EvolutionSpecies, at index: Int, outOf count: Int) -> some View {
        if let pokemon = species.defaultPokemon.first {
            let angle = (360.0 / Double(count)) * Double(index) - 90.0
            let radians = angle * .pi / 180.0
            let cardX = Constants.radialRadius * CGFloat(cos(radians))
            let cardY = Constants.radialRadius * CGFloat(sin(radians))

            pokemonCard(
                species: species,
                pokemon: pokemon,
                imageSize: Constants.radialImageSize,
                cardWidth: Constants.radialCardWidth,
                cardHeight: Constants.radialCardHeight
            )
            .offset(x: cardX, y: cardY)
        }
    }

    private func megaEvolutionSection(_ megaPokemon: [EvolutionPokemon]) -> some View {
        VStack(spacing: Constants.innerSpacing) {
            megaSectionHeader

            HStack {
                ForEach(megaPokemon) { pokemon in
                    megaCard(pokemon: pokemon)
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }

    private var megaSectionHeader: some View {
        HStack {
            Image(systemName: EvolutionTrigger.megaEvolution.icon)
                .foregroundStyle(Color.megaEvolution)

            Text(Constants.megaSectionTitle)
                .font(.title2)
                .bold()
                .foregroundStyle(Color.megaEvolution.exposureAdjust(Constants.megaTitleBrightnessAdjust))
        }
    }

    @ViewBuilder
    private func conditionBadge(for species: EvolutionSpecies? = nil, pokemon: EvolutionPokemon) -> some View {
        let isSelected = selectedPokemonName == pokemon.formattedName
        if let condition = species?.pokemonEvolutions.first,
           let icon = condition.evolutionTrigger?.name.icon
        {
            HStack {
                Image(systemName: icon)
                Text(isSelected ? condition.fullDescription : condition.shortDescription)
                    .foregroundStyle(isSelected ? .primary : .secondary)
                    .bold()
            }
            .padding(.horizontal, Constants.badgeHorizontalPadding)
            .padding(.vertical, Constants.badgeVerticalPadding)
            .containerBackground(cornerRadius: Constants.cornerRadius)
        } else {
            HStack {
                Image(systemName: Constants.baseFormIcon)
                    .scaleEffect(Constants.baseFormIconScale)
                    .bold()
                Text(Constants.baseFormLabel)
                    .foregroundStyle(.primary)
                    .bold()
            }
            .padding(.horizontal, Constants.badgeHorizontalPadding)
            .padding(.vertical, isSelected ? Constants.badgeVerticalPadding : 0)
            .containerBackground(cornerRadius: Constants.cornerRadius)
            .scaleEffect(isSelected ? 1 : 0)
        }
    }

    private func pokemonCard(
        species: EvolutionSpecies,
        pokemon: EvolutionPokemon,
        imageSize: CGFloat = Constants.imageSize,
        cardWidth: CGFloat = Constants.cardWidth,
        cardHeight: CGFloat = Constants.cardHeight
    ) -> some View {
        let isSelected = selectedPokemonName == pokemon.formattedName

        return NavigationLink(value: pokemon.toPokemonListEntry()) {
            cardContent(species: species, pokemon: pokemon, imageSize: imageSize, cardWidth: cardWidth, cardHeight: cardHeight)
        }
        .disabled(!isSelected || pokemon.name == pokemonName)
        .opacity(isSelected ? 1.0 : Constants.unselectedOpacity)
        .simultaneousGesture(TapGesture().onEnded {
            guard !isSelected else { return }
            withAnimation(.spring(duration: Constants.selectionAnimationDuration)) {
                selectedPokemonName = pokemon.formattedName
            }
        })
    }

    private func megaConditionBadge(for pokemon: EvolutionPokemon) -> some View {
        let condition = MegaStones.condition(for: pokemon.name)
        let isSelected = selectedPokemonName == pokemon.formattedName

        return HStack {
            Image(systemName: EvolutionTrigger.megaEvolution.icon)
                .foregroundStyle(Color.megaEvolution)

            Text(isSelected ? condition.fullDescription : condition.shortDescription)
                .font(.default)
                .bold()
                .lineLimit(isSelected ? Constants.megaBadgeExpandedLineLimit : 1)
                .minimumScaleFactor(isSelected ? Constants.nameMinScale : Constants.megaBadgeMinScale)
                .foregroundStyle(Color.megaEvolution.exposureAdjust(Constants.megaBadgeBrightnessAdjust))
        }
        .padding(.horizontal, isSelected ? Constants.megaBadgeHorizontalPadding : Constants.badgeHorizontalPadding)
        .padding(.vertical, Constants.badgeVerticalPadding)
    }

    private func megaCard(pokemon: EvolutionPokemon) -> some View {
        let isSelected = selectedPokemonName == pokemon.formattedName

        return NavigationLink(value: pokemon.toPokemonListEntry()) {
            megaCardContent(pokemon: pokemon)
        }
        .disabled(!isSelected || pokemon.name == pokemonName)
        .opacity(isSelected ? 1.0 : Constants.unselectedOpacity)
        .simultaneousGesture(TapGesture().onEnded {
            guard !isSelected else { return }
            withAnimation(.spring(duration: Constants.selectionAnimationDuration)) {
                selectedPokemonName = pokemon.formattedName
            }
        })
    }

    private func megaCardContent(pokemon: EvolutionPokemon) -> some View {
        VStack {
            PokemonImageView(spriteURL: pokemon.spriteURL)
                .frame(maxWidth: Constants.megaImageSize)
            Text(pokemon.formattedName)
                .font(.title3)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(accentColor)
                .lineLimit(1)
                .minimumScaleFactor(Constants.nameMinScale)

            megaConditionBadge(for: pokemon)
        }
        .padding()
        .frame(maxWidth: Constants.megaCardWidth, maxHeight: Constants.megaCardHeight)
        .containerBackground(
            cornerRadius: Constants.cornerRadius,
            fill: accentColor.opacity(Constants.cardFillOpacity),
            stroke: accentColor,
            lineWidth: Constants.cardBorderWidth
        )
    }

    private func cardContent(
        species: EvolutionSpecies,
        pokemon: EvolutionPokemon,
        imageSize: CGFloat = Constants.imageSize,
        cardWidth: CGFloat = Constants.cardWidth,
        cardHeight: CGFloat = Constants.cardHeight
    ) -> some View {
        VStack {
            PokemonImageView(spriteURL: pokemon.spriteURL)
                .frame(maxWidth: imageSize)
            Text(species.formattedName)
                .font(.default)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(accentColor)
                .lineLimit(1)
                .minimumScaleFactor(Constants.nameMinScale)
        }
        .padding()
        .frame(maxWidth: cardWidth, maxHeight: cardHeight)
        .containerBackground(
            cornerRadius: Constants.cornerRadius,
            fill: accentColor.opacity(Constants.cardFillOpacity),
            stroke: accentColor,
            lineWidth: Constants.cardBorderWidth
        )
    }
}

// MARK: - Constants

extension PokemonEvolutionTab {
    enum Constants {
        static let outerSpacing: CGFloat = 24
        static let innerSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 22
        static let badgeHorizontalPadding: CGFloat = 16
        static let megaBadgeHorizontalPadding: CGFloat = 4
        static let badgeVerticalPadding: CGFloat = 8
        static let imageSize: CGFloat = 75
        static let megaImageSize: CGFloat = 150
        static let cardWidth: CGFloat = 120
        static let cardHeight: CGFloat = 144
        static let megaCardWidth: CGFloat = 200
        static let megaCardHeight: CGFloat = 380
        static let cardFillOpacity: Double = 0.2
        static let cardBorderWidth: CGFloat = 2
        static let unselectedOpacity: Double = 0.7
        static let selectionAnimationDuration: Double = 0.25
        static let nameMinScale: CGFloat = 0.5
        static let megaSectionTitle: String = "MEGA EVOLUTION"
        static let megaTitleBrightnessAdjust: Double = 1.7
        static let megaBadgeBrightnessAdjust: Double = 2.0
        static let megaBadgeMinScale: CGFloat = 0.5
        static let megaBadgeExpandedLineLimit: Int = 3
        static let baseFormIcon: String = "circle"
        static let baseFormIconScale: CGFloat = 0.4
        static let baseFormLabel: String = "Base Form"
        static let noEvolutionRingLineWidth: CGFloat = 1
        static let noEvolutionRingOneScale: CGFloat = 1.5
        static let noEvolutionRingOneOpacity: Double = 0.5
        static let noEvolutionRingTwoScale: CGFloat = 2
        static let noEvolutionRingTwoOpacity: Double = 0.2
        static let noEvolutionCardVerticalPadding: CGFloat = 64
        static let noEvolutionText: String = "has no evolutionary relatives. Its form is final from the moment it hatches."
        static let radialLayoutThreshold: Int = 4
        static let radialRadius: CGFloat = 145
        static let radialContainerSize: CGFloat = 520
        static let radialCardWidth: CGFloat = 80
        static let radialCardHeight: CGFloat = 90
        static let radialImageSize: CGFloat = 48
    }
}

#Preview("Squirtle") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockSquirtle,
            types: PokemonType.mockSquirtleTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Eevee") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockEevee,
            types: PokemonType.mockEeveeTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Charmander") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockCharmander,
            types: PokemonType.mockCharmanderTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Pikachu") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockPikachu,
            types: PokemonType.mockPikachuTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Lapras") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockLapras,
            types: PokemonType.mockLaprasTypes
        )
        .environment(SoundManager())
    }
}
