//
//  PokemonDataService.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

protocol PokemonDataService {
    func fetchPokemonListDetails(url: URL) async throws -> [PokemonListEntry]
    func fetchPokemonTypes(url: URL) async throws -> [PokemonType]
    func fetchPokemonGenerations(url: URL) async throws -> [PokemonGeneration]
}
