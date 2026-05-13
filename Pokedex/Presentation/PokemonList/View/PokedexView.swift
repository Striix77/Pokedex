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

struct PokedexView: View {
    @Bindable var viewModel: PokedexViewModel
    @State var viewType = ViewType.grid

    private let navigationTitle = "Pokédex"
    private let searchPrompt = "Search Pokémon..."
    private let viewTypeLabel = "View Type"
    private let gridLabel = "Grid"
    private let listLabel = "List"
    private let typeFilterLabel = "Type filter"
    private let typePickerLabel = "Type"
    private let allLabel = "All"
    private let generationFilterLabel = "Generation filter"
    private let generationPickerLabel = "Generation"

    var body: some View {
        NavigationStack {
            ZStack{
                PokemonListBackgroundView(stops: stops)
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
                .listRowSpacing(8)
                .navigationTitle(navigationTitle)
                .navigationBarTitleDisplayMode(.inline)
                .searchable(
                    text: $viewModel.filteringService.searchText,
                    prompt: searchPrompt
                )
            }
        }
    }

    private var viewTypeMenu: some View {
        Menu {
            Picker(
                viewTypeLabel,
                selection: $viewType
            ) {
                Text(gridLabel).tag(ViewType.grid)
                Text(listLabel).tag(ViewType.list)
            }
        } label: {
            Label(
                viewTypeLabel,
                systemImage: viewType == .grid
                    ? "square.grid.2x2" : "list.bullet"
            )
        }
    }

    private var typeFilteringMenu: some View {
        Menu {
            Picker(
                typePickerLabel,
                selection: $viewModel.filteringService.selectedTypeFilter
            ) {
                Text(allLabel).tag(allLabel)
                ForEach(viewModel.typeList, id: \.self) { type in
                    Text(type.name.capitalized).tag(
                        type.name.capitalized
                    )
                }
            }
        } label: {
            Label(
                typeFilterLabel,
                systemImage: "line.3.horizontal.decrease.circle"
            )
        }
    }

    private var generationFilteringMenu: some View {
        Menu {
            Picker(
                generationPickerLabel,
                selection: $viewModel.filteringService.selectedGenerationFilter
            ) {
                Text(allLabel).tag(allLabel)
                ForEach(viewModel.generationsList, id: \.self) { generation in
                    Text(generation.formattedName).tag(
                        generation.name
                    )
                }
            }
        } label: {
            Label(
                generationFilterLabel,
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
