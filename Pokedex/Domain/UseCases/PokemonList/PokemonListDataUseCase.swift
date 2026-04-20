//
//  PokemonListDataUseCase.swift
//  Pokedex
//
//  Created by Freak on 20.04.2026.
//
import Foundation

class PokemonListDataUseCase: PokemonListDataUseCaseProtocol {
    private let apiService: PokemonListAPIProtocol

    init(apiService: PokemonListAPIProtocol) {
        self.apiService = apiService
    }

    func execute() async throws -> (list: [PokemonListEntry], types: [PokemonType], generations: [PokemonGeneration]) {
        guard let url = URL(string: PokedexStrings.apiURL) else {
            throw URLError(.badURL)
        }

        async let fetchList = apiService.fetchPokemonList(url: url)
        async let fetchTypes = apiService.fetchPokemonTypes(url: url)
        async let fetchGenerations = apiService.fetchPokemonGenerations(url: url)

        return (try await fetchList, try await fetchTypes, try await fetchGenerations)
    }
}
