//
//  PokemonDetailsAPIProtocol.swift
//  Pokedex
//
//  Created by Freak on 20.04.2026.
//
import Foundation

protocol PokemonDetailsAPIProtocol {
    func fetchPokemonDetails(id: Int, url: URL) async throws -> [PokemonDetailsEntry]
}

