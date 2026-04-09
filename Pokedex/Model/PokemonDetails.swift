//
//  Pokemon.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import Foundation

struct PokemonDetails: Codable, Hashable {
    let weight: Int
    let height: Int
    let pokemonsprites: [SpriteEntry]
    let pokemonstats: [StatEntry]
    let pokemoncries: [PokemonCries]

    var spriteURL: URL? {
        guard let spritesJson = pokemonsprites.first?.sprites else {
            return nil
        }
        print(pokemonsprites)
        if let artworkString = spritesJson.other?.officialArtwork?.front_default
        {
            return URL(string: artworkString)
        }

        return nil
    }

    func statValue(named name: String) -> Int {
        pokemonstats
            .first(where: { $0.stat.name == name })?
            .base_stat ?? 0
    }
}
