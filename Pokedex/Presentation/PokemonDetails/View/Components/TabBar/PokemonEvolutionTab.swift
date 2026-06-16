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

    let pokemonName: String
    let types: [PokemonType]
    let accentColor: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let chain = viewModel.evolutionChain {
                VStack(alignment: .center, spacing: 16) {
                    ForEach(chain.pokemonSpecies) { species in
                        if let pokemon = species.defaultPokemon.first {
                            if species != chain.pokemonSpecies.first {
                                VStack(spacing: 16) {
                                    if let conditions = species.pokemonEvolutions.first?.shortDescription, let icon = species.pokemonEvolutions.first?.evolutionTrigger?.name.icon {
                                        HStack {
                                            Image(systemName: icon)
                                            Text(conditions)
                                                .foregroundStyle(.secondary)
                                                .bold()
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 8)
                                        .containerBackground(cornerRadius: 22)
                                    }
                                }
                            }

                            NavigationLink(value: pokemon.toPokemonListEntry()) {
                                VStack {
                                    PokemonImageView(spriteURL: pokemon.spriteURL)
                                        .frame(maxWidth: 75)

                                    Text(species.formattedName)
                                        .font(.default)
                                        .fontDesign(.rounded)
                                        .bold()
                                        .foregroundStyle(accentColor)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.7)
                                }
                                .padding()
                                .frame(maxWidth: 120, maxHeight: 144)
                                .containerBackground(cornerRadius: 22, fill: accentColor.opacity(0.2), stroke: accentColor, lineWidth: 2)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

//                    ForEach(species.megaPokemon) { mega in
//                        NavigationLink(value: mega.toPokemonListEntry()) {
//                            Text(mega.formattedName)
//                                .font(.title3)
//                                .fontDesign(.rounded)
//                                .bold()
//                                .foregroundStyle(.secondary)
//                            ForEach(mega.displayConditions, id: \.label) { condition in
//                                Text("\(condition.label)".capitalized + " : " + "\(condition.value)".capitalized)
//                            }
//                        }
//                    }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .navigationDestination(for: PokemonListEntry.self) { entry in
            PokemonDetailsView(pokemonListEntry: entry, types: types)
        }
        .task {
            await viewModel.fetchEvolutionChain(pokemonName: pokemonName)
        }
        .fetchingAlert(
            showAlert: $viewModel.showAlert,
            fetchAction: { await viewModel.fetchEvolutionChain(pokemonName: pokemonName) },
            confirmAction: { dismiss() },
            errorMessage: viewModel.errorMessage
        )
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
