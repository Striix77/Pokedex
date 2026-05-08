//
//  Extensions.swift
//  Pokedex
//
//  Created by Freak on 08.05.2026.
//
import SwiftUI

extension EnvironmentValues {
    var favoritesService: any FavoritesServiceProtocol {
        get { self[FavoritesServiceKey.self] }
        set { self[FavoritesServiceKey.self] = newValue }
    }
}
