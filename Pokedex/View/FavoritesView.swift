//
//  FavoritesView.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import SwiftUI

struct FavoritesView: View {
    var viewModel: PokemonViewModel

    var favoritePokemon: [Pokemon] {
        viewModel.list.filter { viewModel.favorites.contains($0.id) }
    }

    private let stops = [
        Gradient.Stop(
            color: Color.favoritesViewBackground1,
            location: 0.0
        ),
        Gradient.Stop(
            color: Color.favoritesViewBackground2,
            location: 0.4
        ),
        Gradient.Stop(
            color: Color.favoritesViewBackground2,
            location: 1.0
        ),
    ]

    var body: some View {
        NavigationStack {

            ZStack {
                PokemonListBackgroundView(stops: stops)
                Group {
                    if favoritePokemon.isEmpty {
                        contentUnavailable
                    } else {
                        pokemonList
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
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
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    @Previewable @State var viewModel = PokemonViewModel()
    FavoritesView(viewModel: viewModel)
}
