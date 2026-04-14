//
//  FavoritesDisplayable.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
protocol FavoritesDisplayable:AnyObject {
    var filteredPokemon: [PokemonListEntry] {get}
    var favoritesManager: FavoritesManagingService {get}
}
