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

    var stats: PokemonStats {
        PokemonStats(
            hp: statValue(named: "hp"),
            atk: statValue(named: "attack"),
            def: statValue(named: "defense"),
            spa: statValue(named: "special-attack"),
            spd: statValue(named: "special-defense"),
            spe: statValue(named: "speed")
        )
    }

    private func statValue(named name: String) -> Int {
        pokemonstats
            .first(where: { $0.stat.name == name })?
            .base_stat ?? 0
    }
}
