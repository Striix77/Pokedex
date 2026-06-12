import Foundation

protocol PokemonEvolutionChainUseCaseProtocol {
    func execute(pokemonName: String) async throws -> EvolutionChainEntry?
}
