//
//  PokemonMovesAPIProtocol.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

protocol PokemonMovesAPIProtocol {
    func fetchPokemonMoves(name: String, versionGroupName: String, url: URL) async throws -> [PokemonMoveEntry]
}
