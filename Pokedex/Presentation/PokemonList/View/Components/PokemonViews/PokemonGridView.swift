//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Freak on 29.04.2026.
//


import SwiftUI

struct PokemonGridView: View {
    let allPokemon: [PokemonListEntry]
    @Binding var searchText: String
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
            .navigationTitle("Pokédex")
            .searchable(
                text: $searchText,
                prompt: "Search Pokémon..."
            )

        }
    }
}
