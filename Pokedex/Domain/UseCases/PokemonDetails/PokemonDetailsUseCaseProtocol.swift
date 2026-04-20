//
//  PokemonDetailsDataUseCaseProtocol.swift
//  Pokedex
//
//  Created by Freak on 20.04.2026.
//
import Foundation

protocol PokemonDetailsUseCaseProtocol {
    func execute(id: Int) async throws -> [PokemonDetailsEntry]
}
