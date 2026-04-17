//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import Foundation

@Observable
class PokemonListViewModel {
    var pokemonList = [PokemonListEntry]()
    var typeList: [PokemonType] = []
    var generationsList: [PokemonGeneration] = []
    var isLoading = false
    var errorMessage: String? = nil

    var favoritesManager = FavoritesManager()
    var filterService = FilterManager()

    var filteredPokemon: [PokemonListEntry] {
        filterService.filterPokemon(pokemonList: pokemonList)
    }

    func fetchPokemon() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: PokedexStrings.apiURL) else {
            isLoading = false
            errorMessage = "URL does not exist or is not accessible!"
            return
        }
        errorMessage = await ErrorHandler.handleFetching {
            async let fetchList: () = fetchPokemonList(url: url)
            async let fetchTypes: () = fetchPokemonTypes(url: url)
            async let fetchGenerations: () = fetchPokemonGenerations(url: url)

            try await fetchList
            try await fetchTypes
            try await fetchGenerations
        }
        isLoading = false
    }

    func fetchPokemonList(url: URL) async throws {
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
        print("decoded list data")

        await MainActor.run {
            self.pokemonList = decoded.data.pokemon
        }

    }

    func fetchPokemonTypes(url: URL) async throws {
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

        await MainActor.run {
            self.typeList = decodedTypes.data.type
        }

    }

    func fetchPokemonGenerations(url: URL) async throws {
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

        await MainActor.run {
            self.generationsList = decodedGenerations.data.generation
        }

    }

}
