//
//  FavoritesView.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//
import SwiftUI

struct FavoritesView: View {
    @Environment(\.favoritesService) var favoritesService
    var viewModel: PokedexViewModel

    var favoritePokemon: [PokemonListEntry] {
        viewModel.pokemonList.filter {
            favoritesService.favoriteIDs.contains($0.id)
        }
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
            ZStack{
                PokemonListBackgroundView(stops: stops)
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
