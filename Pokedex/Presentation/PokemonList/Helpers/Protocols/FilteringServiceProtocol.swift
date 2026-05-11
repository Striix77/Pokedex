//
//  FilteringManagerProtocol.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

protocol FilteringServiceProtocol {
    var searchText: String {
        get
        set
    }
    var selectedTypeFilter: String {
        get
        set
    }
    var selectedGenerationFilter: String {
        get
        set
    }

    func filterPokemon(pokemonList: [PokemonListEntry]) -> [PokemonListEntry]
}
