//
//  FavoritesManaging.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

protocol FavoritesManagingService {
    var favorites: Set<Int> { get }
    func toggleFavorite(pokemonId: Int)
}
