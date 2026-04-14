//
//  PokemonListDisplayable.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

protocol PokemonFetchingService {
    var isLoading: Bool {get}
    var errorMessage: String? {get}
    func fetchPokemon() async
}
