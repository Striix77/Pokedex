//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import Foundation

@Observable
class PokemonListViewModel {
    var pokemonList = [PokemonListEntry]()
    var typeList: [PokemonType] = []
    var generationsList: [PokemonGeneration] = []
    var isLoading = false
    var errorMessage: String? = nil

    private let dataService: PokemonDataService
    let favoritesManager : FavoritesManagingService
    var filteringManager : FilteringService

    var filteredPokemon: [PokemonListEntry] {
        filteringManager.filterPokemon(pokemonList: pokemonList)
    }

    init(dataService: PokemonDataService, favoritesManager: FavoritesManagingService) {
        self.dataService = dataService
        self.favoritesManager = favoritesManager
        self.filteringManager = FilteringManager()
    }

    func fetchPokemon() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: PokedexStrings.apiURL) else {
            return
        }
        errorMessage = await ErrorHandler.handleFetching {
            self.pokemonList = try await dataService.fetchPokemonListDetails(
                url: url
            )
            self.typeList = try await dataService.fetchPokemonTypes(url: url)
            self.generationsList =
                try await dataService.fetchPokemonGenerations(url: url)
        }
        isLoading = false
    }

}
