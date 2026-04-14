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
    let favoritesManager : FavoritesManaging
    var filterService = FilterService()

    var filteredPokemon: [PokemonListEntry] {
        filterService.filterPokemon(pokemonList: pokemonList)
    }

    init(dataService: PokemonDataService, favoritesManager: FavoritesManaging) {
        self.dataService = dataService
        self.favoritesManager = favoritesManager
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
