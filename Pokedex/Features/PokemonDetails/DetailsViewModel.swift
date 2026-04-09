//
//  DetailsViewModel.swift
//  Pokedex
//
//  Created by Freak on 09.04.2026.
//
import SwiftUI

@Observable
class DetailsViewModel {
    var isLoading = true
    var errorMessage: String? = nil
    private var pokemonDetailsArray = [PokemonDetails]()

    var pokemonDetails: PokemonDetails? {
        pokemonDetailsArray.first
    }

    func fetchPokemonDetails(id: Int) async {
        isLoading = true
        guard let url = URL(string: PokedexStrings.apiURL) else {
            return
        }

        errorMessage = await ErrorHandler.handleFetching {
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

            await MainActor.run {
                self.pokemonDetailsArray = decoded.data.pokemon
            }
        }

        isLoading = false
    }
}
