//
//  FavoritesManaging.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

protocol FavoritesManaging {
    var favoriteIDs: Set<Int> { get }
    func toggle(_ id: Int)
}
