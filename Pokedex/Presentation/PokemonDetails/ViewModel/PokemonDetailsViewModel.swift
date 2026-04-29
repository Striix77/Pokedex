//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

@Observable
class PokemonDetailsViewModel {
    var isLoading = true
    var errorMessage: String? = nil
    private var pokemonDetailsArray: Array<PokemonDetailsEntry>
    private let pokemonDetailsUseCase: PokemonDetailsUseCaseProtocol

    var pokemonDetails: PokemonDetailsEntry? {
        pokemonDetailsArray.first
    }
    
    init(pokemonDetailsUseCase: PokemonDetailsUseCaseProtocol){
        self.pokemonDetailsArray = [PokemonDetailsEntry]()
        self.pokemonDetailsUseCase = pokemonDetailsUseCase
    }

    func fetchPokemonDetails(id: Int) async {
        isLoading = true

        errorMessage = await ErrorHandler.handleFetching {
            let detailsArray = try await pokemonDetailsUseCase.execute(id: id)
            
            await MainActor.run{
                self.pokemonDetailsArray = detailsArray
            }
        }
        isLoading = false
    }
}
