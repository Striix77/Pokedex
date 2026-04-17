//
//  FavoritesView.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import SwiftUI

struct FavoritesView: View {
    @Environment(FavoritesService.self) var favoritesService
    var viewModel: PokemonListViewModel

    var favoritePokemon: [PokemonListEntry] {
        viewModel.pokemonList.filter {
            favoritesService.favoriteIDs.contains($0.id)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if favoritePokemon.isEmpty {
                    contentUnavailable
                } else {
                    pokemonList
                }
            }
            .navigationTitle("My Favorites")
            .navigationDestination(for: PokemonListEntry.self) {
                pokemonListEntry in
                PokemonDetailsView(
                    pokemonListEntry: pokemonListEntry,
                    types: viewModel.typeList
                )
            }
        }
    }

    private var contentUnavailable: some View {
        ContentUnavailableView(
            "No Favorites Yet",
            systemImage: "heart.slash",
            description: Text(
                "Go to the list and tap the heart on your favorite Pokémon!"
            )
        )
    }

    private var pokemonList: some View {
        List(favoritePokemon) { pokemon in
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
}
