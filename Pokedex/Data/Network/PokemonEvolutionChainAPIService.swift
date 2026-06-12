import Foundation

class PokemonEvolutionChainAPIService: PokemonEvolutionChainAPIProtocol {
    func fetchEvolutionChain(pokemonName: String, url: URL) async throws -> EvolutionChainEntry? {
        let query = PokemonQueries.getEvolutionChainQuery(for: pokemonName)
        let body: [String: Any] = ["query": query]

        let request = RequestBuilder.buildRequest(to: url, for: query, with: body)

        let (data, _) = try await URLSession.shared.data(for: request)
        let decoded = try JSONDecoder().decode(EvolutionChainResponse.self, from: data)

        return decoded.data.evolutionChain.first
    }
}
