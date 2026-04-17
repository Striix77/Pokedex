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

    var favoritesManager: FavoritesManagerProtocol
    var filterService = FilterManager()

    var filteredPokemon: [PokemonListEntry] {
        filterService.filterPokemon(pokemonList: pokemonList)
    }

    private let apiService: PokemonAPIProtocol

    init(apiService: PokemonAPIProtocol, favoritesManager: FavoritesManagerProtocol) {
        self.apiService = apiService
        self.favoritesManager = favoritesManager
    }

    
    func fetchPokemon() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: PokedexStrings.apiURL) else {
            isLoading = false
            errorMessage = "URL does not exist or is not accessible!"
            return
        }
        errorMessage = await ErrorHandler.handleFetching {
            async let fetchList = apiService.fetchPokemonList(url: url)
            async let fetchTypes = apiService.fetchPokemonTypes(url: url)
            async let fetchGenerations = apiService.fetchPokemonGenerations(
                    url: url
                )

            let list = try await fetchList
            let types = try await fetchTypes
            let generations = try await fetchGenerations
            
            await MainActor.run {
                self.pokemonList = list
                self.typeList = types
                self.generationsList = generations
            }
        }
        isLoading = false
    }
}
