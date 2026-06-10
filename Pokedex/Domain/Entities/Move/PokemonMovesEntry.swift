//
//  PokemonMovesEntry.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

struct PokemonMovesEntry: Codable {
    let name: String
    let pokemonmoves: [PokemonMoveEntry]
}
