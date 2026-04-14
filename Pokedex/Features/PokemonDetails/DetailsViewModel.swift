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
    private var detailsService: DetailsDataService
    
    init(detailsService: DetailsDataService){
        self.detailsService = detailsService
    }

    var pokemonDetails: PokemonDetails? {
        pokemonDetailsArray.first
    }

    func fetchPokemonDetails(id: Int) async {
        isLoading = true
        guard let url = URL(string: PokedexStrings.apiURL) else {
            return
        }

        errorMessage = await ErrorHandler.handleFetching {
            pokemonDetailsArray = try await detailsService.fetchPokemonDetails(id: id, url: url)
        }

        isLoading = false
    }
}
