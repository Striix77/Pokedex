//
//  PokemonDetailsDataUseCase.swift
//  Pokedex
//
//  Created by Freak on 20.04.2026.
//
import Foundation

class PokemonDetailsUseCase: PokemonDetailsUseCaseProtocol {
    private let apiService: PokemonDetailsAPIProtocol

    init(apiService: PokemonDetailsAPIProtocol) {
        self.apiService = apiService
    }

    func execute(id: Int) async throws -> [PokemonDetailsEntry] {
        guard let url = URL(string: PokedexStrings.apiURL) else {
            throw URLError(.badURL)
        }

        async let fetchDetails = apiService.fetchPokemonDetails(id: id, url: url)
        return try await fetchDetails
    }
}
