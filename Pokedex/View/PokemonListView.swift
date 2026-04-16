//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonListView: View {
    @State var viewModel: PokemonViewModel
    private let stops = [
        Gradient.Stop(
            color: Color(red: 0.898, green: 0.4196, blue: 0.4275),
            location: 0.0
        ),
        Gradient.Stop(
            color: Color(red: 0.4471, green: 0.1529, blue: 0.2784),
            location: 1.0
        ),
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                PokemonListBackgroundView(stops: stops)
                if viewModel.isLoading && viewModel.list.isEmpty {
                    ProgressView("Catching 'em all...")
                } else if viewModel.errorMessage != nil {
                    contentUnavailable
                } else {
                    pokemonList
                }
            }
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

    private var pokemonList: some View {
        List(viewModel.filteredPokemon) { pokemon in
            NavigationLink(value: pokemon) {
                HStack {
                    Text("#\(pokemon.id)")
                        .font(
                            .system(
                                size: 16,
                                weight: .semibold,
                                design: .monospaced
                            )
                        )
                        .padding(6)

                    Text(pokemon.name.capitalized)
                        .font(
                            .system(
                                size: 20,
                                weight: .bold
                            )
                        )
                        .bold()

                    Spacer()
                    Spacer()

                }
                .padding(8)
            }
            .listRowBackground(
                Rectangle()
                    .fill(.ultraThinMaterial)
            )
            .listRowSeparator(.hidden)

        }
        .navigationTitle("Pokédex")
        .searchable(
            text: $viewModel.searchText,
            prompt: "Search Pokémon..."
        )
        .onAppear {
            Task {
                await viewModel.fetchPokemon()
            }
        }
        .navigationDestination(for: Pokemon.self) { pokemon in
            PokemonDetailsView(
                pokemon: pokemon,
                isFavorite: viewModel.favorites.contains(pokemon.id),
                onFavoriteToggle: {
                    viewModel.toggleFavorite(pokemon: pokemon)
                }
            )
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    @Previewable @State var viewModel = PokemonViewModel()
    PokemonListView(viewModel: viewModel)
}
