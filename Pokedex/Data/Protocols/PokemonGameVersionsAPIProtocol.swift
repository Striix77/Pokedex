import Foundation

protocol PokemonGameVersionsAPIProtocol {
    func fetchPokemonGameVersions(name: String, url: URL) async throws -> [PokemonGameVersion]
}

