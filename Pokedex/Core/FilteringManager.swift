//
//  FilterService.swift
//  Pokedex
//
//  Created by Freak on 09.04.2026.
//
import SwiftUI

@Observable
class FilteringManager {
    var searchText = ""
    var selectedTypeFilter: String = "All"
    var selectedGenerationFilter: String = "All"
    
    func filterPokemon(pokemonList: [PokemonListEntry]) -> [PokemonListEntry] {
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

    private func filterByTypes(in pokemonList: [PokemonListEntry]) -> [PokemonListEntry]
    {
        if selectedTypeFilter == "All" {
            return pokemonList
        } else {
            return pokemonList.filter { pokemon in
                pokemon.typeString.contains(selectedTypeFilter)
            }
        }
    }

    private func filterByGenerations(in pokemonList: [PokemonListEntry])
        -> [PokemonListEntry]
    {
        if selectedGenerationFilter == "All" {
            return pokemonList
        } else {
            return pokemonList.filter { pokemon in
                pokemon.generationName == selectedGenerationFilter
            }
        }
    }
}
