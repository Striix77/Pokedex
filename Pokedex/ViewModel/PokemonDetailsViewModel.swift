//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import SwiftUI

@Observable
class PokemonDetailsViewModel{
    var isLoading = true
    var errorMessage: String? = nil
    private var pokemonDetailsArray = [PokemonDetailsEntry]()
    
    var pokemonDetails : PokemonDetailsEntry? {
        pokemonDetailsArray.first
    }
    
    func fetchPokemonDetails(id: Int) async {
        isLoading = true
        errorMessage = nil
        guard let url = URL(string: PokedexStrings.apiURL) else {
            return
        }

        let query = PokemonQueries.getPokemonDetailsQuery(for: id)

        let body: [String: Any] = ["query": query]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print("got the list data")
            let decoded = try JSONDecoder().decode(
                PokemonDetailsResponse.self,
                from: data
            )
            print("decoded")

            await MainActor.run {
                self.pokemonDetailsArray = decoded.data.pokemon
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
