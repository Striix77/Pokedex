//
//  PokemonMovesUseCaseProtocol.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import Foundation

protocol PokemonMovesUseCaseProtocol {
    func execute(name: String, versionGroupName: String) async throws -> [PokemonMoveEntry]
}
