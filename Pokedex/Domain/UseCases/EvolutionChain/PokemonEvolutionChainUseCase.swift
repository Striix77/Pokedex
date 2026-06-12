import Foundation

class PokemonEvolutionChainUseCase: PokemonEvolutionChainUseCaseProtocol {
    private let apiService: PokemonEvolutionChainAPIProtocol

    init(apiService: PokemonEvolutionChainAPIProtocol) {
        self.apiService = apiService
    }

    func execute(pokemonName: String) async throws -> EvolutionChainEntry? {
        guard let url = URL(string: PokedexStrings.apiURL) else {
            throw URLError(.badURL)
        }
        return try await apiService.fetchEvolutionChain(pokemonName: pokemonName, url: url)
    }
}
