//
//  PokedexView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

enum ViewType: String {
    case list
    case grid
}

struct PokedexView: View {
    @Bindable var viewModel: PokedexViewModel
    @State var viewType = ViewType.grid

    var body: some View {
        NavigationStack {
            Group {
                switch viewType {
                case .grid:
                    PokemonGridView(
                        allPokemon: viewModel.filteredPokemon,
                        typeList: viewModel.typeList
                    )
                case .list:
                    PokemonListView(
                        allPokemon: viewModel.filteredPokemon,
                        typeList: viewModel.typeList
                    )
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    viewTypeMenu
                    typeFilteringMenu
                    generationFilteringMenu
                }
            }
            .navigationTitle("Pokédex")
            .searchable(
                text: $viewModel.filteringService.searchText,
                prompt: "Search Pokémon..."
            )
        }
    }

    private var viewTypeMenu: some View {
        Menu {
            Picker(
                "View Type",
                selection: $viewType
            ) {
                Text("Grid").tag(ViewType.grid)
                Text("List").tag(ViewType.list)
            }
        } label: {
            Label(
                "View Type",
                systemImage: viewType == .grid
                    ? "square.grid.2x2" : "list.bullet"
            )
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
        .task {
            await viewModel.fetchPokemon()
        }
        .environment(SoundManager())
        .environment(FavoritesService())

}
