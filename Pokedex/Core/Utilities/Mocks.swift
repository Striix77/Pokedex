//
//  Mocks.swift
//  Pokedex
//
//  Created by Freak on 29.05.2026.
//
import Foundation

extension PokemonListEntry {
    static var mock: PokemonListEntry {
        PokemonListEntry(
            id: 1,
            name: "bulbasaur",
            pokemontypes: [
                PokemonTypes(type: PokemonType(
                    id: 12,
                    name: "grass",
                    typeEfficaciesByTargetTypeId: nil
                )),
                PokemonTypes(type: PokemonType(
                    id: 4,
                    name: "poison",
                    typeEfficaciesByTargetTypeId: nil
                ))
            ],
            pokemonspecy: SpeciesEntry(
                generation: PokemonGeneration(name: "generation-i")
            ),
            pokemonsprites: [
                SpriteEntry(sprites: SpriteData(
                    other: OtherSprites(
                        officialArtwork: OfficialArtwork(
                            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/1.png"
                        )
                    )
                ))
            ]
        )
    }
}

extension PokemonType {
    static var mockTypes: [PokemonType] {
        [
            PokemonType(id: 12, name: "grass", typeEfficaciesByTargetTypeId: [
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 10, name: "fire")),
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 15, name: "ice")),
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 3, name: "flying")),
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 7, name: "bug")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 11, name: "water")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 13, name: "electric")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 12, name: "grass"))
            ]),
            PokemonType(id: 4, name: "poison", typeEfficaciesByTargetTypeId: [
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 6, name: "ground")),
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 14, name: "psychic")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 2, name: "fighting")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 4, name: "poison")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 12, name: "grass")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 18, name: "fairy"))
            ])
        ]
    }
}
