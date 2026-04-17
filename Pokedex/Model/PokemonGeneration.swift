//
//  PokemonGeneration.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//
import Foundation

struct PokemonGeneration: Codable, Hashable {
    let name: String
    
    var formattedName: String {
        let raw = name.replacingOccurrences(
            of: "generation-",
            with: ""
        )
        return "Gen \(raw.uppercased())"
    }
}
