//
//  PokemonDetailsAPIService.swift
//  Pokedex
//
//  Created by Freak on 20.04.2026.
//
import Foundation

class PokemonDetailsAPIService: PokemonDetailsAPIProtocol{
    func fetchPokemonDetails(id: Int, url: URL) async throws -> [PokemonDetailsEntry] {
        let query = PokemonQueries.getPokemonDetailsQuery(for: id)
        let body: [String: Any] = ["query": query]

        let request = RequestBuilder.buildRequest(to: url, for: query, with: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        print("got the list data")
        let decoded = try JSONDecoder().decode(
            PokemonDetailsResponse.self,
            from: data
        )
        print("decoded")

        return decoded.data.pokemon
    }
    
}
