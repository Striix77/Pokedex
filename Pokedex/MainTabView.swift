//
//  MainTabView.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var viewModel = PokedexViewModel(
        pokemonListDataUseCase: PokemonListDataUseCase(
            apiService: PokemonListAPIService(),
        ),
        filteringService: FilteringService()
    )
    @State private var soundManager = SoundManager()
    @State private var favoritesService = FavoritesService()

    var body: some View {
        TabView {
            if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                ProgressView("Catching 'em all...")
            } else if viewModel.errorMessage != nil {
                contentUnavailable
            } else {
                PokedexView(viewModel: viewModel)
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
        .environment(soundManager)
        .environment(favoritesService)
    }

    private var contentUnavailable: some View {
        ContentUnavailableView {
            Label(
                viewModel.errorMessage ?? "Connection Lost",
                systemImage: "wifi.exclamationmark"
            )
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
