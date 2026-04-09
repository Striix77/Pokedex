//
//  Pokemon.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import Foundation

struct PokemonListEntry: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let pokemontypes: [PokemonTypes]
    let pokemonspecy: SpeciesEntry?

    var typeString: String {
        pokemontypes.map { $0.type.name.capitalized }
            .joined(separator: ", ")
    }

    var generationName: String {
        return pokemonspecy?.generation?.name ?? "Unknown"
    }

    var formattedGeneration: String {
        let raw = generationName.replacingOccurrences(
            of: "generation-",
            with: ""
        )
        return "Gen \(raw.uppercased())"
    }
}
