//
//  PokemonListEntry.swift
//  Pokedex
//
//  Created by Freak on 17.04.2026.
//
import Foundation

struct PokemonListEntry: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let pokemontypes: [PokemonTypes]
    let pokemonspecy: SpeciesEntry?
    let pokemonsprites: [SpriteEntry]
    
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

    var typeString: String {
        pokemontypes.map { $0.type.name.capitalized }
            .joined(separator: ", ")
    }

    var generationName: String {
        return pokemonspecy?.generation?.name ?? "Unknown"
    }

    var formattedGeneration: String {
        let raw = generationName.replacingOccurrences(
            of: "generation-",
            with: ""
        )
        return "Gen \(raw.uppercased())"
    }
}
