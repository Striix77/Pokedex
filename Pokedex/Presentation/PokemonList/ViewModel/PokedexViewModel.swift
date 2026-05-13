//
//  PokedexViewModel.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//
import Foundation

@Observable
@MainActor
class PokedexViewModel {
    var pokemonList: [PokemonListEntry]
    var typeList: [PokemonType]
    var generationsList: [PokemonGeneration]

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
        errorMessage = await ErrorHandler.handleFetching {
            let data = try await pokemonListDataUseCase.execute()

            self.pokemonList = data.list
            self.typeList = data.types
            self.generationsList = data.generations

        }
        isLoading = false
    }
}
