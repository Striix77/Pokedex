//
//  PokemonMoveEntry.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

struct PokemonMoveEntry: Codable, Hashable {
    let id: Int
    let level: Int
    let movelearnmethod: MoveLearnMethod
    let move: MoveEntry
}
