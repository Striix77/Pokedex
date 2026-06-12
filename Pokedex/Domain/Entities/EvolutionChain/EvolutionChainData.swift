import Foundation

struct EvolutionChainData: Codable {
    let evolutionChain: [EvolutionChainEntry]

    enum CodingKeys: String, CodingKey {
        case evolutionChain = "evolutionchain"
    }
}

struct EvolutionChainEntry: Codable {
    let pokemonSpecies: [EvolutionSpecies]

    enum CodingKeys: String, CodingKey {
        case pokemonSpecies = "pokemonspecies"
    }
}
