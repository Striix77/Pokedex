//
//  Pokemon.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import Foundation

struct Pokemon: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let pokemontypes: [PokemonTypes]
    let pokemonspecy: SpeciesEntry?
    let weight: Int
    let height: Int
    let pokemonsprites: [SpriteEntry]
    let pokemonstats: [StatEntry]

    var spriteURL: URL? {
        guard let spritesJson = pokemonsprites.first?.sprites else {
            return nil
        }
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

    func statValue(named name: String) -> Int {
        pokemonstats
            .first(where: { $0.stat.name == name })?
            .base_stat ?? 0
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

extension Pokemon {
    static func mock(id: Int, name: String) -> Pokemon {
        return Pokemon(
            id: id,
            name: name,
            pokemontypes: [
                PokemonTypes(type: PokemonType(id: 11, name: "water", typeEfficaciesByTargetTypeId: nil))
            ],
            pokemonspecy: nil,
            weight:0,
            height:0,
            pokemonsprites: [],
            pokemonstats: [
                StatEntry(
                    base_stat: 50,
                    stat: StatDetails(name: "hp")
                )
            ],
        )
    }
}
