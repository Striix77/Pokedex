import Foundation

struct EvolutionSpecies: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
    let evolvesFromSpeciesId: Int?
    let pokemonEvolutions: [EvolutionCondition]
    let defaultPokemon: [EvolutionPokemon]
    let megaPokemon: [MegaEvolution]

    var formattedName: String {
        name.capitalized
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case evolvesFromSpeciesId = "evolves_from_species_id"
        case pokemonEvolutions = "pokemonevolutions"
        case defaultPokemon
        case megaPokemon
    }
}
