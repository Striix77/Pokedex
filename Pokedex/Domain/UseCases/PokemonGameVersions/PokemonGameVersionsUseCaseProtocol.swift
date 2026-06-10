import Foundation

protocol PokemonGameVersionsUseCaseProtocol {
    func execute(name: String) async throws -> [PokemonGameVersion]
}
