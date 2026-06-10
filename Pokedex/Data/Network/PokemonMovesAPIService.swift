//
//  PokemonMovesAPIService.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

class PokemonMovesAPIService: PokemonMovesAPIProtocol {
    func fetchPokemonMoves(name: String, versionGroupName: String, url: URL) async throws -> [PokemonMoveEntry] {
        let query = PokemonQueries.getMovesQuery(for: name, versionGroupName: versionGroupName)
        let body: [String: Any] = ["query": query]

        let request = RequestBuilder.buildRequest(to: url, for: query, with: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(PokemonMovesResponse.self, from: data)

        return decoded.data.pokemon.first?.pokemonmoves ?? []
    }
}
