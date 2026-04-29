//
//  PokedexView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokedexView: View {
    @Bindable var viewModel: PokedexViewModel

    var body: some View {
        NavigationStack {
            PokedexListView(
                allPokemon: viewModel.filteredPokemon,
                searchText: $viewModel.filteringService.searchText
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
    @Previewable @State var viewModel = PokedexViewModel(
        pokemonListDataUseCase: PokemonListDataUseCase(
            apiService: PokemonListAPIService()
        ),
        filteringService: FilteringService()
    )
    PokedexView(viewModel: viewModel)
}
