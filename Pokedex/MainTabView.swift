//
//  MainTabView.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var viewModel = PokemonListViewModel()

    var body: some View {
        TabView {
            if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                ProgressView("Catching 'em all...")
            } else if viewModel.errorMessage != nil {
                contentUnavailable
            } else {
                PokemonListView(viewModel: viewModel)
                    .tabItem {
                        Label("All Pokémon", systemImage: "bolt.fill")
                    }
                FavoritesView(viewModel: viewModel)
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
        }
        .task {
            await viewModel.fetchPokemon()
        }
    }

    private var contentUnavailable: some View {
        ContentUnavailableView {
            Label("Connection Lost", systemImage: "wifi.exclamationmark")
        } description: {
            Text(
                "Looks like Team Rocket is at it again...\nMaybe try again later!"
            )
        } actions: {
            Button("Try Again") {
                Task { await viewModel.fetchPokemon() }
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

}

#Preview {
    MainTabView()
}
