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
            apiService: PokemonListAPIService()
        ),
        filteringService: FilteringService()
    )
    @State private var soundManager = SoundManager()
    @State private var favoritesService = FavoritesService()
    @State private var showContent = false

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
        ZStack {
            if !showContent {
                progressView
            } else if viewModel.errorMessage != nil {
                contentUnavailable
            } else {
                tabView
            }
        }
        .animation(.easeInOut(duration: 1), value: showContent)
        .task {
            await viewModel.fetchPokemon()
        }
        .environment(soundManager)
        .environment(\.favoritesService, favoritesService)
    }

    private var progressView: some View {
        VStack {
            PokeballProgressView(isLoading: $viewModel.isLoading) {
                showContent = true
            }
            .frame(width: 40)
            Text(loadingLabel)
        }
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
                showContent = false
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }

    private var tabView: some View {
        TabView {
            PokedexView(viewModel: viewModel)
                .tabItem {
                    Label(allPokemonLabel, systemImage: allPokemonIcon)
                }
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label(favoritesLabel, systemImage: favoritesIcon)
                }
        }
        .transition(.opacity)
    }
}

#Preview {
    MainTabView()
}
