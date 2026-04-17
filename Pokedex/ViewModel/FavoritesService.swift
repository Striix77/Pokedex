//
//  FavoritesManager.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import SwiftUI

@Observable
class FavoritesService: FavoritesServiceProtocol {
    var favoriteIDs: Set<Int> = [] {
        didSet {
            saveFavorites()
        }
    }

    init() {
        loadFavorites()
    }

    func toggle(_ pokemonId: Int) {
        if favoriteIDs.contains(pokemonId) {
            favoriteIDs.remove(pokemonId)
        } else {
            favoriteIDs.insert(pokemonId)
        }
    }

    private func saveFavorites() {
        let array = Array(favoriteIDs)
        UserDefaults.standard.set(array, forKey: "favorite_pokemon")
    }

    private func loadFavorites() {
        if let array = UserDefaults.standard.array(forKey: "favorite_pokemon")
            as? [Int]
        {
            favoriteIDs = Set(array)
        }
    }
}
