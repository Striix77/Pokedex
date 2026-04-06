//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import Foundation

@Observable
class PokemonViewModel {
    var list = [Pokemon]()
    var typeList: [PokemonType] = []
    var generationsList: [PokemonGeneration] = []
    var searchText = ""
    var isLoading = false
    var errorMessage: String? = nil
    var selectedFilter: String = "All"

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

    var filteredPokemon: [Pokemon] {
        var searchedList: [Pokemon]
        if searchText.isEmpty {
            searchedList =  list
        } else {
            searchedList = list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
        return filterByTypes(in: searchedList)
    }

    func filterByTypes(in pokemonList: [Pokemon]) -> [Pokemon] {
        if selectedFilter == "All" {
            return pokemonList
        } else {
            return pokemonList.filter { pokemon in
                pokemon.typeString.contains(selectedFilter)
            }
        }
    }

    func fetchPokemon() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: "https://graphql.pokeapi.co/v1beta2") else {
            return
        }

        let query = PokemonQueries.pokemonBaseQuery
        let typeQuery = PokemonQueries.pokemonTypesQuery
        let generationsQuery = PokemonQueries.pokemonGenerationsQuery

        let body: [String: Any] = ["query": query]
        let typeBody: [String: Any] = ["query": typeQuery]
        let generationsBody: [String: Any] = ["query": generationsQuery]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        var typeRequest = URLRequest(url: url)
        typeRequest.httpMethod = "POST"
        typeRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        typeRequest.httpBody = try? JSONSerialization.data(
            withJSONObject: typeBody
        )
        
        var generationsRequest = URLRequest(url: url)
        generationsRequest.httpMethod = "POST"
        generationsRequest.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        generationsRequest.httpBody = try? JSONSerialization.data(
            withJSONObject: generationsBody
        )

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("got the data")
            let decoded = try JSONDecoder().decode(
                RootResponse.self,
                from: data
            )
            print("decoded")

            // Types
            let (typeData, _) = try await URLSession.shared.data(
                for: typeRequest
            )
            print("got the types")
            let decodedTypes = try JSONDecoder().decode(
                TypeResponse.self,
                from: typeData
            )
            print("decoded types")
            
            // Generations
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
                self.list = decoded.data.pokemon
                self.typeList = decodedTypes.data.type
                self.generationsList = decodedGenerations.data.generation
            }
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

}
