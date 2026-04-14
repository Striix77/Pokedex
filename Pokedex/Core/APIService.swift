//
//  APIService.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

class APIService: PokemonDataService{
    func fetchPokemonListDetails(url: URL) async throws -> [PokemonListEntry] {
        let query = PokemonQueries.pokemonListQuery
        let body: [String: Any] = ["query": query]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        print("got the list data")
        let decoded = try JSONDecoder().decode(
            ListResponse.self,
            from: data
        )
        print("decoded")

        return decoded.data.pokemon
        
    }

    func fetchPokemonTypes(url: URL) async throws -> [PokemonType] {
        let typeQuery = PokemonQueries.pokemonTypesQuery
        let typeBody: [String: Any] = ["query": typeQuery]
        var typeRequest = URLRequest(url: url)
        typeRequest.httpMethod = "POST"
        typeRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        typeRequest.httpBody = try? JSONSerialization.data(
            withJSONObject: typeBody
        )
        let (typeData, _) = try await URLSession.shared.data(
            for: typeRequest
        )
        print("got the types")
        let decodedTypes = try JSONDecoder().decode(
            TypeResponse.self,
            from: typeData
        )
        print("decoded types")

        return decodedTypes.data.type
        
    }

    func fetchPokemonGenerations(url: URL) async throws -> [PokemonGeneration] {
        let generationsQuery = PokemonQueries.pokemonGenerationsQuery
        let generationsBody: [String: Any] = ["query": generationsQuery]
        var generationsRequest = URLRequest(url: url)
        generationsRequest.httpMethod = "POST"
        generationsRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        generationsRequest.httpBody = try? JSONSerialization.data(
            withJSONObject: generationsBody
        )
        let (generationsData, _) = try await URLSession.shared.data(
            for: generationsRequest
        )
        print("got the generations")
        let decodedGenerations = try JSONDecoder().decode(
            GenerationResponse.self,
            from: generationsData
        )
        print("decoded generations")

        return decodedGenerations.data.generation
        

    }
    
    
}
