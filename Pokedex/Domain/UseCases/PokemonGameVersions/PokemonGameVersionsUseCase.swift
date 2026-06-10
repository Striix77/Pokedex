import Foundation

class PokemonGameVersionsUseCase: PokemonGameVersionsUseCaseProtocol {
    private let apiService: PokemonGameVersionsAPIProtocol

    init(apiService: PokemonGameVersionsAPIProtocol) {
        self.apiService = apiService
    }

    func execute(name: String) async throws -> [PokemonGameVersion] {
        guard let url = URL(string: PokedexStrings.apiURL) else {
            throw URLError(.badURL)
        }

        async let fetchGameVersions = apiService.fetchPokemonGameVersions(name: name, url: url)
        return try await fetchGameVersions
    }
}
