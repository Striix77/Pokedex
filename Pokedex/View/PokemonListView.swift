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
            color: Color.listViewBackground1,
            location: 0.0
        ),
        Gradient.Stop(
            color: Color.listViewBackground2,
            location: 0.4
        ),
        Gradient.Stop(
            color: Color.listViewBackground2,
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
        .task {
            await viewModel.fetchPokemon()
        }
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

    private var pokemonList: some View {
        VStack {
            List(viewModel.filteredPokemon) { pokemon in
                NavigationLink(value: pokemon) {
                    HStack {
                        ZStack {
                            Text("#\(pokemon.id)")
                                .font(.caption)
                                .fontDesign(.monospaced)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.ultraThinMaterial.opacity(0.5))
                                .clipShape(Capsule())
                                .overlay(
                                    Capsule().stroke(
                                        .white.opacity(0.2),
                                        lineWidth: 1
                                    )
                                )

                        }

                        Text(pokemon.name.capitalized)
                            .bold()

                    }
                    .frame(alignment: .leading)
                    .font(.title3)
                    .padding(8)
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 8).fill(
                        .ultraThinMaterial.opacity(0.5)
                    )
                )
                .listRowSeparator(.hidden)

            }
            .listRowSpacing(8)
            .navigationTitle("Pokédex")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(
                text: $viewModel.searchText,
                prompt: "Search Pokémon..."
            )
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    typeFilteringMenu
                    generationFilteringMenu
                }
            }
            .scrollContentBackground(.hidden)
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

    private var typeFilteringMenu: some View {
        Menu {
            Picker("Type", selection: $viewModel.selectedTypeFilter) {
                Text("All").tag("All")
                ForEach(viewModel.typeList, id: \.self) { type in
                    Text(type.name.capitalized).tag(
                        type.name.capitalized
                    )
                }
            }
        } label: {
            Label(
                "Type filter",
                systemImage: "line.3.horizontal.decrease.circle"
            )
        }
    }

    private var generationFilteringMenu: some View {
        Menu {
            Picker("Generation", selection: $viewModel.selectedGenerationFilter)
            {
                Text("All").tag("All")
                ForEach(viewModel.generationsList, id: \.self) { generation in
                    Text(generation.formattedName).tag(
                        generation.name
                    )
                }
            }
        } label: {
            Label(
                "Generation filter",
                systemImage: "number.circle"
            )
        }
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    @Previewable @State var viewModel = PokemonViewModel()
    PokemonListView(viewModel: viewModel)
}
