//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonListView: View {
    @Bindable var viewModel: PokemonListViewModel

    var body: some View {
        NavigationStack {
            pokemonList
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
                text: $viewModel.filteringService.searchText,
                prompt: "Search Pokémon..."
            )
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    typeFilteringMenu
                    generationFilteringMenu
                }
            }

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
    }
}

#Preview {
    @Previewable @State var viewModel = PokemonListViewModel(
        pokemonListDataUseCase: PokemonListDataUseCase(
            apiService: PokemonAPIService()
        ),
        filteringService: FilteringService()
    )
    PokemonListView(viewModel: viewModel)
}
