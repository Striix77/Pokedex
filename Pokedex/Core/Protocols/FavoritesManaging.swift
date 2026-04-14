//
//  FavoritesManaging.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

protocol FavoritesManaging {
    var favorites: Set<Int> { get }
    func toggleFavorite(pokemonId: Int)
}
