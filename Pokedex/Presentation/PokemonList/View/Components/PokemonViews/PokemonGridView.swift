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
    var body: some View {
        VStack {
            List(allPokemon) { pokemon in
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
    NavigationStack{
        PokemonGridView(allPokemon:viewModel.filteredPokemon, typeList: viewModel.typeList)
            .task{
                await viewModel.fetchPokemon()
            }
    }
        
}
