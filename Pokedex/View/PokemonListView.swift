//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonListView: View {
    @State var viewModel: PokemonViewModel

    var body: some View {
        NavigationStack {
            if viewModel.isLoading && viewModel.list.isEmpty {
                ProgressView("Catching 'em all...")
            } else if viewModel.errorMessage != nil {
                contentUnavailable
            } else {
                pokemonList
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
        VStack {
            List(viewModel.filteredPokemon) { pokemon in
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
            .navigationTitle("Pokédex")
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search Pokémon..."
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $viewModel.selectedFilter) {
                            Text("All").tag("All")
                            ForEach(viewModel.typeList, id: \.self) { type in
                                Text(type.name.capitalized).tag(
                                    type.name.capitalized
                                )
                            }
                        }
                    } label: {
                        Label(
                            "Filter",
                            systemImage: "line.3.horizontal.decrease.circle"
                        )
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker("Filter", selection: $viewModel.selectedFilter) {
                            Text("All").tag("All")
                            ForEach(viewModel.typeList, id: \.self) { type in
                                Text(type.name.capitalized).tag(
                                    type.name.capitalized
                                )
                            }
                        }
                    } label: {
                        Label(
                            "Filter",
                            systemImage: "line.3.horizontal.decrease.circle"
                        )
                    }
                }
            }
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

        }
    }
}

#Preview{
    @Previewable @State var viewModel = PokemonViewModel()
    PokemonListView(viewModel: viewModel)
}
