//
//  PokemonDetailTab.swift
//  Pokedex
//
//  Created by Freak on 02.06.2026.
//
import Foundation

enum PokemonDetailTab: CaseIterable {
    case about, stats, moves, evolution

    var title: String {
        switch self {
        case .about: "About"
        case .stats: "Stats"
        case .moves: "Moves"
        case .evolution: "Evolution"
        }
    }
}
