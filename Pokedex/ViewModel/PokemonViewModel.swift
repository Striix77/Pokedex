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
    var searchText = ""
    var isLoading = false
    var errorMessage: String? = nil

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
        if searchText.isEmpty {
            return list
        } else {
            return list.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func fetchPokemon() async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: "https://graphql.pokeapi.co/v1beta2") else {
            return
        }

        let query = PokemonQueries.getPokemonList

        let body: [String: Any] = ["query": query]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("got the data")
            let decoded = try JSONDecoder().decode(
                RootResponse.self,
                from: data
            )
            print("decoded")

            await MainActor.run {
                self.list = decoded.data.pokemon
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
