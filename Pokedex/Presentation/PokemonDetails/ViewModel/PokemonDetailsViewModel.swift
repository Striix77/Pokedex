//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

@Observable
@MainActor
class PokemonDetailsViewModel {
    var isLoading = true
    var errorMessage: String? = nil
    var showAlert: Bool = false
    private var pokemonDetailsArray: [PokemonDetailsEntry]
    private let pokemonDetailsUseCase: PokemonDetailsUseCaseProtocol

    var pokemonDetails: PokemonDetailsEntry? {
        pokemonDetailsArray.first
    }

    init(pokemonDetailsUseCase: PokemonDetailsUseCaseProtocol) {
        self.pokemonDetailsArray = [PokemonDetailsEntry]()
        self.pokemonDetailsUseCase = pokemonDetailsUseCase
    }

    func fetchPokemonDetails(id: Int) async {
        isLoading = true

        errorMessage = await ErrorHandler.handleFetching {
            let detailsArray = try await pokemonDetailsUseCase.execute(id: id)

            self.pokemonDetailsArray = detailsArray
        }
        showAlert = errorMessage != nil
        isLoading = false
    }
}
