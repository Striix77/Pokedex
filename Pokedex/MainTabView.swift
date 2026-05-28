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

    private let loadingLabel = "Catching 'em all..."
    private let allPokemonLabel = "All Pokémon"
    private let allPokemonIcon = "bolt.fill"
    private let favoritesLabel = "Favorites"
    private let favoritesIcon = "heart.fill"
    private let errorIcon = "wifi.exclamationmark"
    private let fallbackErrorMessage = "Connection Lost"
    private let errorDescription = "Looks like Team Rocket is at it again...\nMaybe try again later!"
    private let tryAgainLabel = "Try Again"

    var body: some View {
        TabView {
            if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                ProgressView(loadingLabel)
            } else if viewModel.errorMessage != nil {
                contentUnavailable
            } else {
                PokedexView(viewModel: viewModel)
                    .tabItem {
                        Label(allPokemonLabel, systemImage: allPokemonIcon)
                    }
                FavoritesView(viewModel: viewModel)
                    .tabItem {
                        Label(favoritesLabel, systemImage: favoritesIcon)
                    }
            }
        }
        .task {
            await viewModel.fetchPokemon()
        }
        .environment(soundManager)
        .environment(\.favoritesService, favoritesService)
    }

    private var contentUnavailable: some View {
        ContentUnavailableView {
            Label(
                viewModel.errorMessage ?? fallbackErrorMessage,
                systemImage: errorIcon
            )
        } description: {
            Text(errorDescription)
        } actions: {
            Button(tryAgainLabel) {
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
