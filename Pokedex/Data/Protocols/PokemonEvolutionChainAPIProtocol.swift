import Foundation

protocol PokemonEvolutionChainAPIProtocol {
    func fetchEvolutionChain(pokemonName: String, url: URL) async throws -> EvolutionChainEntry?
}
