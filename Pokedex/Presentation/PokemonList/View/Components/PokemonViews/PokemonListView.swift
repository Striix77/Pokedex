//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Freak on 29.04.2026.
//

import SwiftUI

struct PokemonListView: PokemonViewProtocol {
    let allPokemon: [PokemonListEntry]
    let typeList: [PokemonType]
    var body: some View {
        VStack {
            List(allPokemon) { pokemon in
                NavigationLink(value: pokemon) {
                    HStack {
                        ZStack {
                            Text("#\(pokemon.id)")
                                .font(.caption)
                                .fontDesign(.monospaced)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial.opacity(0.5))
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(
                                        .white.opacity(0.2),
                                        lineWidth: 1
                                    )
                                )
                        }

                        Text(pokemon.name.capitalized)
                            .bold()
                    }
                    .frame(alignment: .leading)
                    .font(.title3)
                    .padding(8)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 8).fill(
                        .ultraThinMaterial.opacity(0.5)
                    )
                )
                .listRowSeparator(.hidden)
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
}
