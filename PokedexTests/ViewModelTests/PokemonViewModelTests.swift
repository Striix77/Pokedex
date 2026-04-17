//
//  PokemonViewModelTests.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import Testing
@testable import Pokedex

@Suite("ViewModel Logic Tests")
struct PokemonViewModelTests {

    @Test(
        "Search filtering is case-insensitive",
        arguments: ["PIKA", "pika", "PikA"]
    )
    func searchFiltering(query: String) {
        let viewModel = PokemonListViewModel()
        viewModel.list = [Pokemon.mock(id: 25, name: "Pikachu")]

        viewModel.searchText = query

        #expect(viewModel.filteredPokemon.count == 1)
        #expect(viewModel.filteredPokemon.first?.name == "Pikachu")
    }

    @Test("Toggling favorites updates the collection")
    func favoriteToggle() {
        let viewModel = PokemonListViewModel()
        let pika = Pokemon.mock(id: 25, name: "Pikachu")

        viewModel.toggleFavorite(pokemon:pika)
        #expect(viewModel.favorites.contains(25))

        viewModel.toggleFavorite(pokemon:pika)
        #expect(viewModel.favorites.isEmpty)
    }
}
