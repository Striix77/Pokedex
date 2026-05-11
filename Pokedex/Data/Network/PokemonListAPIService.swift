//
//  PokemonListAPIService.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

class PokemonListAPIService: PokemonListAPIProtocol {

    func fetchPokemonList(url: URL) async throws -> [PokemonListEntry] {
        let query = PokemonQueries.pokemonListQuery
        let body: [String: Any] = ["query": query]
        let request = RequestBuilder.buildRequest(to: url, for: query, with: body)
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(
            ListResponse.self,
            from: data
        )

        return decoded.data.pokemon

    }

    func fetchPokemonTypes(url: URL) async throws -> [PokemonType] {
        let typeQuery = PokemonQueries.pokemonTypesQuery
        let typeBody: [String: Any] = ["query": typeQuery]
        let typeRequest = RequestBuilder.buildRequest(to: url, for: typeQuery, with: typeBody)
        let (typeData, _) = try await URLSession.shared.data(
            for: typeRequest
        )
        let decodedTypes = try JSONDecoder().decode(
            TypeResponse.self,
            from: typeData
        )

        return decodedTypes.data.type

    }

    func fetchPokemonGenerations(url: URL) async throws -> [PokemonGeneration] {
        let generationsQuery = PokemonQueries.pokemonGenerationsQuery
        let generationsBody: [String: Any] = ["query": generationsQuery]
        let generationsRequest = RequestBuilder.buildRequest(to: url, for: generationsQuery, with: generationsBody)
        let (generationsData, _) = try await URLSession.shared.data(
            for: generationsRequest
        )
        let decodedGenerations = try JSONDecoder().decode(
            GenerationResponse.self,
            from: generationsData
        )

        return decodedGenerations.data.generation
    }
}
