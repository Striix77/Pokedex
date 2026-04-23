//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import Foundation

@Observable
class PokemonListViewModel {
    var pokemonList: Array<PokemonListEntry>
    var typeList: Array<PokemonType>
    var generationsList: Array<PokemonGeneration>
    
    var isLoading = false
    var errorMessage: String? = nil
    
    var filteringService: FilteringServiceProtocol
    var filteredPokemon: [PokemonListEntry] {
        filteringService.filterPokemon(pokemonList: pokemonList)
    }

    private let apiService: PokemonAPIProtocol

    init(
        apiService: PokemonAPIProtocol,
        filteringService: FilteringServiceProtocol
    ) {
        self.apiService = apiService
        self.filteringService = filteringService
        
        pokemonList = [PokemonListEntry]()
        typeList = [PokemonType]()
        generationsList = [PokemonGeneration]()
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
