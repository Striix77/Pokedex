//
//  DetailsDataService.swift
//  Pokedex
//
//  Created by Freak on 14.04.2026.
//
import Foundation

protocol DetailsDataService {
    func fetchPokemonDetails(id: Int, url: URL) async throws -> [PokemonDetails]
}
