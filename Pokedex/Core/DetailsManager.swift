//
//  DetailsService.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

class DetailsManager: DetailsDataService{
    func fetchPokemonDetails(id: Int, url: URL) async throws -> [PokemonDetails] {
        let query = PokemonQueries.getPokemonDetailsQuery(for: id)

        let body: [String: Any] = ["query": query]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        print("got the list data")
        let decoded = try JSONDecoder().decode(
            DetailsResponse.self,
            from: data
        )
        print("decoded")

        return decoded.data.pokemon
    }
    
    
}
