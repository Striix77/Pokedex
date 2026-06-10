//
//  PokemonMovesUseCase.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

class PokemonMovesUseCase: PokemonMovesUseCaseProtocol {
    private let apiService: PokemonMovesAPIProtocol

    init(apiService: PokemonMovesAPIProtocol) {
        self.apiService = apiService
    }

    func execute(name: String, versionGroupName: String) async throws -> [PokemonMoveEntry] {
        guard let url = URL(string: PokedexStrings.apiURL) else {
            throw URLError(.badURL)
        }

        return try await apiService.fetchPokemonMoves(name: name, versionGroupName: versionGroupName, url: url)
    }
}
