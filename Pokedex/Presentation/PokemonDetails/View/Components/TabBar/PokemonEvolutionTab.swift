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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let chain = viewModel.evolutionChain {
                ForEach(chain.pokemonSpecies) { species in
                    if let pokemon = species.defaultPokemon.first {
                        NavigationLink(value: pokemon.toPokemonListEntry()) {
                            Text(species.formattedName)
                                .font(.title3)
                                .fontDesign(.rounded)
                                .bold()
                        }
                    }

                    ForEach(species.megaPokemon) { mega in
                        NavigationLink(value: mega.toPokemonListEntry()) {
                            Text(mega.formattedName)
                                .font(.title3)
                                .fontDesign(.rounded)
                                .bold()
                                .foregroundStyle(.secondary)
                        }
                    }
                }
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
