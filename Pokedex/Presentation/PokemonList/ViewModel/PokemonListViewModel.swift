//
//  PokemonViewModel.swift
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

    private let pokemonListDataUseCase: PokemonListDataUseCaseProtocol

    init(
        pokemonListDataUseCase: PokemonListDataUseCaseProtocol,
        filteringService: FilteringServiceProtocol
    ) {
        self.pokemonListDataUseCase = pokemonListDataUseCase
        self.filteringService = filteringService
        
        pokemonList = [PokemonListEntry]()
        typeList = [PokemonType]()
        generationsList = [PokemonGeneration]()
    }

    func fetchPokemon() async {
        isLoading = true
        errorMessage = nil
        errorMessage = await ErrorHandler.handleFetching {
            let data = try await pokemonListDataUseCase.execute()
            
            await MainActor.run {
                self.pokemonList = data.list
                self.typeList = data.types
                self.generationsList = data.generations
            }
        }
        isLoading = false
    }
}
