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
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    var body: some View {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allPokemon) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonGridCard(pokemon: pokemon)
                        }
                    }
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .navigationDestination(for: PokemonListEntry.self) {
                pokemonListEntry in
                PokemonDetailsView(
                    pokemonListEntry: pokemonListEntry,
                    types: typeList
                )
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

#Preview("Pokedex") {
    @Previewable @State var viewModel = PokedexViewModel(
        pokemonListDataUseCase: PokemonListDataUseCase(
            apiService: PokemonListAPIService()
        ),
        filteringService: FilteringService()
    )
    PokedexView(viewModel: viewModel)
        .task {
            await viewModel.fetchPokemon()
        }
        .environment(SoundManager())
        .environment(FavoritesService())

}
