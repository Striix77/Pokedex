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
    @State private var selectedEvolutionSpecies: EvolutionSpecies? = nil

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

                            if selectedEvolutionSpecies == species {
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
                            else {
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
                                .opacity(0.8)
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.25)) {
                                        selectedEvolutionSpecies = species
                                    }
                                }
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)

                
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
