//
//  PokemonListDataUseCaseProtocol.swift
//  Pokedex
//
//  Created by Freak on 20.04.2026.
//
import Foundation

protocol PokemonListDataUseCaseProtocol {
    func execute() async throws -> (list: [PokemonListEntry], types: [PokemonType], generations: [PokemonGeneration])
}
