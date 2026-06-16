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
    @State private var selectedSpecies: EvolutionSpecies?
    @State private var selectedMegaPokemon: EvolutionPokemon?

    let pokemonName: String
    let types: [PokemonType]
    let accentColor: Color

    private var pokemonNameForFetching: String {
        pokemonName.replacing(/-mega.*/, with: "")
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Constants.outerSpacing) {
            if let chain = viewModel.evolutionChain {
                VStack(alignment: .center, spacing: Constants.innerSpacing) {
                    ForEach(chain.pokemonSpecies) { species in
                        if let pokemon = species.defaultPokemon.first {
                            if species != chain.pokemonSpecies.first {
                                conditionBadge(for: species)
                            }
                            pokemonCard(species: species, pokemon: pokemon)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                
                if let megaPokemon = chain.pokemonSpecies.last?.megaPokemon, !megaPokemon.isEmpty {
                    ForEach(megaPokemon) { pokemon in
                        megaConditionBadge(for: pokemon)
                        megaCard(pokemon: pokemon)
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    private func conditionBadge(for species: EvolutionSpecies) -> some View {
        if let condition = species.pokemonEvolutions.first,
           let icon = condition.evolutionTrigger?.name.icon
        {
            HStack {
                Image(systemName: icon)
                Text(condition.shortDescription)
                    .foregroundStyle(.secondary)
                    .bold()
            }
            .padding(.horizontal, Constants.badgeHorizontalPadding)
            .padding(.vertical, Constants.badgeVerticalPadding)
            .containerBackground(cornerRadius: Constants.cornerRadius)
        }
    }

    @ViewBuilder
    private func pokemonCard(species: EvolutionSpecies, pokemon: EvolutionPokemon) -> some View {
        if selectedSpecies == species {
            NavigationLink(value: pokemon.toPokemonListEntry()) {
                cardContent(species: species, pokemon: pokemon)
            }
        } else {
            cardContent(species: species, pokemon: pokemon)
                .opacity(Constants.unselectedOpacity)
                .onTapGesture {
                    withAnimation(.linear(duration: Constants.selectionAnimationDuration)) {
                        selectedSpecies = species
                    }
                }
        }
    }

    @ViewBuilder
    private func megaConditionBadge(for pokemon: EvolutionPokemon) -> some View {
        let condition = MegaStones.condition(for: pokemon.name)
        HStack {
            Image(systemName: EvolutionTrigger.megaEvolution.icon)
            Text(condition.shortDescription)
                .foregroundStyle(.secondary)
                .bold()
        }
        .padding(.horizontal, Constants.badgeHorizontalPadding)
        .padding(.vertical, Constants.badgeVerticalPadding)
        .containerBackground(cornerRadius: Constants.cornerRadius)
    }

    @ViewBuilder
    private func megaCard(pokemon: EvolutionPokemon) -> some View {
        if selectedMegaPokemon == pokemon {
            NavigationLink(value: pokemon.toPokemonListEntry()) {
                megaCardContent(pokemon: pokemon)
            }
        } else {
            megaCardContent(pokemon: pokemon)
                .opacity(Constants.unselectedOpacity)
                .onTapGesture {
                    withAnimation(.linear(duration: Constants.selectionAnimationDuration)) {
                        selectedMegaPokemon = pokemon
                    }
                }
        }
    }

    private func megaCardContent(pokemon: EvolutionPokemon) -> some View {
        VStack {
            PokemonImageView(spriteURL: pokemon.spriteURL)
                .frame(maxWidth: Constants.imageSize)
            Text(pokemon.formattedName)
                .font(.default)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding()
        .frame(maxWidth: Constants.cardWidth, maxHeight: Constants.cardHeight)
        .containerBackground(
            cornerRadius: Constants.cornerRadius,
            fill: accentColor.opacity(Constants.cardFillOpacity),
            stroke: accentColor,
            lineWidth: Constants.cardBorderWidth
        )
    }

    private func cardContent(species: EvolutionSpecies, pokemon: EvolutionPokemon) -> some View {
        VStack {
            PokemonImageView(spriteURL: pokemon.spriteURL)
                .frame(maxWidth: Constants.imageSize)
            Text(species.formattedName)
                .font(.default)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(accentColor)
                .lineLimit(1)
                .minimumScaleFactor(0.7)
        }
        .padding()
        .frame(maxWidth: Constants.cardWidth, maxHeight: Constants.cardHeight)
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
        static let outerSpacing: CGFloat = 12
        static let innerSpacing: CGFloat = 16
        static let cornerRadius: CGFloat = 22
        static let badgeHorizontalPadding: CGFloat = 16
        static let badgeVerticalPadding: CGFloat = 8
        static let imageSize: CGFloat = 75
        static let cardWidth: CGFloat = 120
        static let cardHeight: CGFloat = 144
        static let cardFillOpacity: Double = 0.2
        static let cardBorderWidth: CGFloat = 2
        static let unselectedOpacity: Double = 0.8
        static let selectionAnimationDuration: Double = 0.25
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
