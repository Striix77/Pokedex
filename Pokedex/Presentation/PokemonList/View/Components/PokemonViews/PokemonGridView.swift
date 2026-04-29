//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Freak on 29.04.2026.
//

import SwiftUI

struct PokemonGridView: PokemonViewProtocol {
    let allPokemon: [PokemonListEntry]
    let typeList: [PokemonType]

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(allPokemon) { pokemon in
                        NavigationLink(value: pokemon) {
                            HStack {
                                Text("\(pokemon.id)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                Text(pokemon.name.capitalized)
                                    .bold()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationDestination(for: PokemonListEntry.self) {
                pokemonListEntry in
                PokemonDetailsView(
                    pokemonListEntry: pokemonListEntry,
                    types: typeList
                )
            }
        }
    }
}

#Preview {
    @Previewable @State var viewModel = PokedexViewModel(
        pokemonListDataUseCase: PokemonListDataUseCase(
            apiService: PokemonListAPIService()
        ),
        filteringService: FilteringService()
    )
    NavigationStack {
        PokemonGridView(
            allPokemon: viewModel.filteredPokemon,
            typeList: viewModel.typeList
        )
        .task {
            await viewModel.fetchPokemon()
        }
    }

}
