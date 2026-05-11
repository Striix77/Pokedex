//
//  FavoritesManagerProtocol.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

protocol FavoritesServiceProtocol {
    var favoriteIDs: Set<Int> { get }
    func toggle(_ pokemonId: Int)
}
