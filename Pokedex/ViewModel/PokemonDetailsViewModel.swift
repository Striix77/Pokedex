//
//  PokemonDetailsViewModel.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

@Observable
class PokemonDetailsViewModel {
    var isLoading = true
    var errorMessage: String? = nil
    private var pokemonDetailsArray: Array<PokemonDetailsEntry>

    var pokemonDetails: PokemonDetailsEntry? {
        pokemonDetailsArray.first
    }
    
    init(){
        pokemonDetailsArray = [PokemonDetailsEntry]()
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

        errorMessage = await ErrorHandler.handleFetching {
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
        }
        isLoading = false
    }
}
