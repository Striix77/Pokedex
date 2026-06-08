//
//  PokemonDetailsEntry.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

struct PokemonDetailsEntry: Codable, Hashable {
    let weight: Int
    let height: Int
    let pokemonstats: [StatEntry]
    let pokemonspecy: SpeciesEntry?

    func statValue(named name: String) -> Int {
        pokemonstats
            .first(where: { $0.stat.name == name })?
            .base_stat ?? 0
    }
}
