//
//  PokemonStats.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

struct PokemonStats: Codable, Hashable {
    let hp: Int
    let atk: Int
    let def: Int
    let spa: Int
    let spd: Int
    let spe: Int

    var statsWithLabels: [(label: String, value: Int)] {
        [
            (label: "HP", value: hp),
            (label: "ATK", value: atk),
            (label: "DEF", value: def),
            (label: "SPA", value: spa),
            (label: "SPD", value: spd),
            (label: "SPE", value: spe),
        ]
    }
}
