//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonListView: View {
    @Bindable var viewModel: PokemonListViewModel

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
                pokemonList
            }
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
                text: $viewModel.filteringService.searchText,
                prompt: "Search Pokémon..."
            )
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    typeFilteringMenu
                    generationFilteringMenu
                }
            }
            .scrollContentBackground(.hidden)
            .navigationDestination(for: PokemonListEntry.self) {
                pokemonListEntry in
                PokemonDetailsView(
                    pokemonListEntry: pokemonListEntry,
                    types: viewModel.typeList
                )
            }

        }
    }

    private var typeFilteringMenu: some View {
        Menu {
            Picker(
                "Type",
                selection: $viewModel.filteringService.selectedTypeFilter
            ) {
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
            Picker(
                "Generation",
                selection: $viewModel.filteringService.selectedGenerationFilter
            ) {
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
    @Previewable @State var viewModel = PokemonListViewModel(
        apiService: PokemonAPIService(),
        filteringService: FilteringService()
    )
    PokemonListView(viewModel: viewModel)
}
