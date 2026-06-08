//
//  SpeciesEntry.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//
import Foundation

struct SpeciesEntry: Codable, Hashable {
    let generation: PokemonGeneration?
    let pokemonspeciesnames: [SpeciesNameEntry]?
    let pokemonspeciesflavortexts: [FlavorTextEntry]?

    var flavorText: String? {
        pokemonspeciesflavortexts?.first?.cleanedText
    }

    var genus: String? {
        pokemonspeciesnames?.first?.genus
            .split(separator: " ")
            .dropLast()
            .joined(separator: " ")
    }
}
