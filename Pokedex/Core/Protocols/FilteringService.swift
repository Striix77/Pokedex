//
//  FilteringService.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

protocol FilteringService {
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
