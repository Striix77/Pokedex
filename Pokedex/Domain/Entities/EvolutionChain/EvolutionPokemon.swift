import Foundation

struct EvolutionPokemon: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let pokemonTypes: [EvolutionPokemonType]
    let pokemonSprites: [EvolutionSpriteEntry]
    let pokemonSpecy: SpeciesEntry?

    var spriteURL: URL? {
        guard let urlString = pokemonSprites.first?.sprites else { return nil }
        return URL(string: urlString)
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pokemonTypes = "pokemontypes"
        case pokemonSprites = "pokemonsprites"
        case pokemonSpecy = "pokemonspecy"
    }
}

struct MegaEvolution: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let pokemonTypes: [EvolutionPokemonType]
    let pokemonSprites: [EvolutionSpriteEntry]
    let pokemonSpecy: SpeciesEntry?
    let pokemonForms: [EvolutionPokemonForm]

    var spriteURL: URL? {
        guard let urlString = pokemonSprites.first?.sprites else { return nil }
        return URL(string: urlString)
    }

    var formattedName: String {
        name.split(separator: "-")
            .map { $0.capitalized }
            .joined(separator: " ")
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case pokemonTypes = "pokemontypes"
        case pokemonSprites = "pokemonsprites"
        case pokemonSpecy = "pokemonspecy"
        case pokemonForms = "pokemonforms"
    }
}

extension EvolutionPokemon {
    func toPokemonListEntry() -> PokemonListEntry {
        PokemonListEntry(
            id: id,
            name: name,
            pokemontypes: pokemonTypes.map {
                PokemonTypes(type: PokemonType(id: $0.type.id, name: $0.type.name, typeEfficaciesByTargetTypeId: nil))
            },
            pokemonspecy: pokemonSpecy,
            pokemonsprites: pokemonSprites.compactMap { entry in
                guard let urlString = entry.sprites else { return nil }
                return SpriteEntry(sprites: SpriteData(other: OtherSprites(officialArtwork: OfficialArtwork(front_default: urlString))))
            }
        )
    }
}

extension MegaEvolution {
    var evolutionCondition: EvolutionCondition {
        MegaStones.condition(for: name)
    }

    var displayConditions: [EvolutionCondition.DisplayCondition] {
        evolutionCondition.displayConditions
    }

    func toPokemonListEntry() -> PokemonListEntry {
        PokemonListEntry(
            id: id,
            name: name,
            pokemontypes: pokemonTypes.map {
                PokemonTypes(type: PokemonType(id: $0.type.id, name: $0.type.name, typeEfficaciesByTargetTypeId: nil))
            },
            pokemonspecy: pokemonSpecy,
            pokemonsprites: pokemonSprites.compactMap { entry in
                guard let urlString = entry.sprites else { return nil }
                return SpriteEntry(sprites: SpriteData(other: OtherSprites(officialArtwork: OfficialArtwork(front_default: urlString))))
            }
        )
    }
}

struct EvolutionPokemonType: Codable, Hashable {
    let type: EvolutionTypeEntry
}

struct EvolutionSpriteEntry: Codable, Hashable {
    let sprites: String?
}

struct EvolutionPokemonForm: Codable, Hashable {
    let formName: String

    enum CodingKeys: String, CodingKey {
        case formName = "form_name"
    }
}
