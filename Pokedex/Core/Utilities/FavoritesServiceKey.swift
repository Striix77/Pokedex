//
//  FavoritesServiceKey.swift
//  Pokedex
//
//  Created by Freak on 08.05.2026.
//
import SwiftUI

struct FavoritesServiceKey: EnvironmentKey {
    static let defaultValue: any FavoritesServiceProtocol = FavoritesService()
}
