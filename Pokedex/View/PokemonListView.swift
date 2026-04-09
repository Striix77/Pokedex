//
//  PokemonListView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonListView: View {
    @State var viewModel: PokemonListViewModel

    var body: some View {
        NavigationStack {
            if viewModel.isLoading && viewModel.pokemonList.isEmpty {
                ProgressView("Catching 'em all...")
            } else if viewModel.errorMessage != nil {
                contentUnavailable
            } else {
                pokemonList
            }
        }
        .task {
            await viewModel.fetchPokemon()
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
                ToolbarItemGroup(placement: .topBarTrailing) {
                    typeFilteringMenu
                    generationFilteringMenu
                }
            }
            
            .navigationDestination(for: PokemonListEntry.self) { pokemonEntry in
                PokemonDetailsView(
                    pokemonEntry: pokemonEntry,
                    types: viewModel.typeList,
                    isFavorite: viewModel.favorites.contains(pokemonEntry.id),
                    onFavoriteToggle: {
                        viewModel.toggleFavorite(pokemon: pokemonEntry)
                    }
                )
            }

        }
    }
    
    private var typeFilteringMenu: some View{
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
    
    private var generationFilteringMenu: some View{
        Menu {
            Picker("Generation", selection: $viewModel.selectedGenerationFilter) {
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


#Preview{
    @Previewable @State var viewModel = PokemonListViewModel()
    PokemonListView(viewModel: viewModel)
}
