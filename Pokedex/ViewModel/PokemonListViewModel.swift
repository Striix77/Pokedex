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

    var list = [Pokemon]()
    var typeList: [PokemonType] = []
    var generationsList: [PokemonGeneration] = []
    var searchText = ""
    var isLoading = false
    var errorMessage: String? = nil
    var selectedTypeFilter: String = "All"
    var selectedGenerationFilter: String = "All"

    var favorites: Set<Int> = [] {
        didSet {
            saveFavorites()
        }
    }

    init() {
        loadFavorites()
    }

    func toggleFavorite(pokemon: Pokemon) {
        let pokemonId = pokemon.id
        if favorites.contains(pokemonId) {
            favorites.remove(pokemonId)
        } else {
            favorites.insert(pokemonId)
        }
    }

    private func saveFavorites() {
        let array = Array(favorites)
        UserDefaults.standard.set(array, forKey: "favorite_pokemon")
    }

    private func loadFavorites() {
        if let array = UserDefaults.standard.array(forKey: "favorite_pokemon")
            as? [Int]
        {
            favorites = Set(array)
        }
    }

    var filteredPokemon: [PokemonListEntry] {
        var searchedList: [PokemonListEntry]
        if searchText.isEmpty {
            searchedList = pokemonList
        } else {
            searchedList = pokemonList.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        return filterByGenerations(in: filterByTypes(in: searchedList))
    }

    func filterByTypes(in pokemonList: [PokemonListEntry]) -> [PokemonListEntry] {
        if selectedTypeFilter == "All" {
            return pokemonList
        } else {
            return pokemonList.filter { pokemon in
                pokemon.typeString.contains(selectedTypeFilter)
            }
        }
    }

    func filterByGenerations(in pokemonList: [PokemonListEntry]) -> [PokemonListEntry] {
        if selectedGenerationFilter == "All" {
            return pokemonList
        } else {
            return pokemonList.filter { pokemon in
                pokemon.generationName == selectedGenerationFilter
            }
        }
    }

    func fetchPokemon() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: PokedexStrings.apiURL) else {
            isLoading = false
            errorMessage = "URL does not exist or is not accessible!"
            return
        }

        do {
            async let fetchList: () = fetchPokemonList(url: url)

            async let fetchAll: () = fetchAllPokemonDetails(url: url)
            async let fetchTypes: () = fetchPokemonTypes(url: url)
            async let fetchGenerations: () = fetchPokemonGenerations(url: url)

            try await fetchList

            try await fetchAll
            try await fetchTypes
            try await fetchGenerations
        } catch {
            self.errorMessage = error.localizedDescription
            if let decodingError = error as? DecodingError {
                switch decodingError {
                case .keyNotFound(let key, _):
                    print("❌ Missing Key: \(key.stringValue)")
                case .typeMismatch(let type, let context):
                    print("❌ Type Mismatch: \(type) at \(context.codingPath)")
                case .valueNotFound(let type, let context):
                    print("❌ Value Not Found: \(type) at \(context.codingPath)")
                case .dataCorrupted(let context):
                    print("❌ Data Corrupted at \(context.codingPath)")
                @unknown default:
                    print("❌ Unknown Decoding Error")
                }
            } else {
                print("❌ Other error: \(error.localizedDescription)")
            }
        }
        isLoading = false
    }

    func fetchAllPokemonDetails(url: URL) async throws {
        let query = PokemonQueries.pokemonBaseQuery
        let body: [String: Any] = ["query": query]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        print("got all data")
        let decoded = try JSONDecoder().decode(
            RootResponse.self,
            from: data
        )
        print("decoded")

        await MainActor.run {
            self.list = decoded.data.pokemon
        }

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
