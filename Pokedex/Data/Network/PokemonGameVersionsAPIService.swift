//
//  PokemonDetailsAPIService.swift
//  Pokedex
//
//  Created by Freak on 20.04.2026.
//
import Foundation

class PokemonGameVersionsAPIService: PokemonGameVersionsAPIProtocol{
    func fetchPokemonGameVersions(name: String, url: URL) async throws -> [PokemonGameVersion] {
        let query = PokemonQueries.getQueryForVersionGroups(for: name)
        let body: [String: Any] = ["query": query]

        let request = RequestBuilder.buildRequest(to: url, for: query, with: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        print("got the game versions data")
        let decoded = try JSONDecoder().decode(
            PokemonGameVersionsResponse.self,
            from: data
        )
        print("decoded")

        return decoded.data.versiongroup
    }
    
}
