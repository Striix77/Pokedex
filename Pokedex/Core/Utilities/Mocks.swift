//
//  Mocks.swift
//  Pokedex
//
//  Created by Freak on 29.05.2026.
//
import Foundation

extension PokemonListEntry {
    static var mockSquirtle: PokemonListEntry {
        PokemonListEntry(
            id: 7,
            name: "squirtle",
            pokemontypes: [
                PokemonTypes(type: PokemonType(
                    id: 11,
                    name: "water",
                    typeEfficaciesByTargetTypeId: nil
                ))
            ],
            pokemonspecy: SpeciesEntry(
                generation: PokemonGeneration(name: "generation-i"),
                pokemonspeciesnames: [SpeciesNameEntry(genus: "Tiny Turtle")],
                pokemonspeciesflavortexts: [FlavorTextEntry(flavor_text: "After birth, its back swells and hardens into a shell. It powerfully sprays foam from its mouth to keep enemies at bay.")]
            ),
            pokemonsprites: [
                SpriteEntry(sprites: SpriteData(
                    other: OtherSprites(
                        officialArtwork: OfficialArtwork(
                            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/7.png"
                        )
                    )
                ))
            ]
        )
    }

    static var mockBulbasaur: PokemonListEntry {
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
                generation: PokemonGeneration(name: "generation-i"),
                pokemonspeciesnames: [SpeciesNameEntry(genus: "Seed")],
                pokemonspeciesflavortexts: [FlavorTextEntry(flavor_text: "A strange seed was planted on its back at birth. The plant sprouts and grows with this Pokémon, drawing energy from sunlight.")]
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

extension PokemonListEntry {
    static var mockPikachu: PokemonListEntry {
        PokemonListEntry(
            id: 25,
            name: "pikachu",
            pokemontypes: [
                PokemonTypes(type: PokemonType(id: 13, name: "electric", typeEfficaciesByTargetTypeId: nil))
            ],
            pokemonspecy: SpeciesEntry(
                generation: PokemonGeneration(name: "generation-i"),
                pokemonspeciesnames: [SpeciesNameEntry(genus: "Mouse")],
                pokemonspeciesflavortexts: [FlavorTextEntry(flavor_text: "When several of these Pokémon gather, their electricity can build and cause lightning storms.")]
            ),
            pokemonsprites: [
                SpriteEntry(sprites: SpriteData(
                    other: OtherSprites(
                        officialArtwork: OfficialArtwork(
                            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/25.png"
                        )
                    )
                ))
            ]
        )
    }

    static var mockCharmander: PokemonListEntry {
        PokemonListEntry(
            id: 4,
            name: "charmander",
            pokemontypes: [
                PokemonTypes(type: PokemonType(id: 10, name: "fire", typeEfficaciesByTargetTypeId: nil))
            ],
            pokemonspecy: SpeciesEntry(
                generation: PokemonGeneration(name: "generation-i"),
                pokemonspeciesnames: [SpeciesNameEntry(genus: "Lizard")],
                pokemonspeciesflavortexts: [FlavorTextEntry(flavor_text: "Obviously prefers hot places. When it rains, steam is said to spout from the tip of its tail.")]
            ),
            pokemonsprites: [
                SpriteEntry(sprites: SpriteData(
                    other: OtherSprites(
                        officialArtwork: OfficialArtwork(
                            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/4.png"
                        )
                    )
                ))
            ]
        )
    }

    static var mockEevee: PokemonListEntry {
        PokemonListEntry(
            id: 133,
            name: "eevee",
            pokemontypes: [
                PokemonTypes(type: PokemonType(id: 1, name: "normal", typeEfficaciesByTargetTypeId: nil))
            ],
            pokemonspecy: SpeciesEntry(
                generation: PokemonGeneration(name: "generation-i"),
                pokemonspeciesnames: [SpeciesNameEntry(genus: "Evolution")],
                pokemonspeciesflavortexts: [FlavorTextEntry(flavor_text: "Its genetic code is irregular. It may mutate if it is exposed to radiation from element stones.")]
            ),
            pokemonsprites: [
                SpriteEntry(sprites: SpriteData(
                    other: OtherSprites(
                        officialArtwork: OfficialArtwork(
                            front_default: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/133.png"
                        )
                    )
                ))
            ]
        )
    }
}

extension PokemonType {
    static var mockSquirtleTypes: [PokemonType] {
        [
            PokemonType(id: 11, name: "water", typeEfficaciesByTargetTypeId: [
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 13, name: "electric")),
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 12, name: "grass")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 10, name: "fire")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 11, name: "water")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 15, name: "ice")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 9, name: "steel"))
            ])
        ]
    }

    static var mockPikachuTypes: [PokemonType] {
        [
            PokemonType(id: 13, name: "electric", typeEfficaciesByTargetTypeId: [
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 6, name: "ground")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 3, name: "flying")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 9, name: "steel")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 13, name: "electric"))
            ])
        ]
    }

    static var mockCharmanderTypes: [PokemonType] {
        [
            PokemonType(id: 10, name: "fire", typeEfficaciesByTargetTypeId: [
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 11, name: "water")),
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 6, name: "ground")),
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 5, name: "rock")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 10, name: "fire")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 12, name: "grass")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 15, name: "ice")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 7, name: "bug")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 9, name: "steel")),
                TypeEfficacy(damageFactor: 50, type: AttackerType(id: 18, name: "fairy"))
            ])
        ]
    }

    static var mockEeveeTypes: [PokemonType] {
        [
            PokemonType(id: 1, name: "normal", typeEfficaciesByTargetTypeId: [
                TypeEfficacy(damageFactor: 200, type: AttackerType(id: 2, name: "fighting")),
                TypeEfficacy(damageFactor: 0, type: AttackerType(id: 8, name: "ghost"))
            ])
        ]
    }

    static var mockBulbasaurTypes: [PokemonType] {
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
