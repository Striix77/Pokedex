//
//  PokemonAPIProtocol.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

protocol PokemonAPIProtocol {
    func fetchPokemonList(url: URL) async throws -> [PokemonListEntry]
    func fetchPokemonTypes(url: URL) async throws -> [PokemonType]
    func fetchPokemonGenerations(url: URL) async throws -> [PokemonGeneration]
}
