//
//  FavoritesView.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import SwiftUI

struct FavoritesView: View {
    var viewModel: PokemonListViewModel

    var favoritePokemon: [Pokemon] {
        viewModel.list.filter { viewModel.favorites.contains($0.id) }
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
            .navigationDestination(for: Pokemon.self) { pokemon in
                PokemonDetailsView(
                    pokemon: pokemon,
                    types: viewModel.typeList,
                    isFavorite: viewModel.favorites.contains(pokemon.id),
                    onFavoriteToggle: {
                        viewModel.toggleFavorite(pokemon: pokemon)
                    }
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
