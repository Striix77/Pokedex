import Foundation

@Observable
@MainActor
class PokemonMovesViewModel {
    var isLoading = true
    var errorMessage: String? = nil
    var showAlert: Bool = false
    var pokemonGameVersions: [PokemonGameVersion]
    
    private let pokemonGameVersionsUseCase: PokemonGameVersionsUseCaseProtocol

    init(pokemonGameVersionsUseCase: PokemonGameVersionsUseCaseProtocol) {
        self.pokemonGameVersions = [PokemonGameVersion]()
        self.pokemonGameVersionsUseCase = pokemonGameVersionsUseCase
    }

    func fetchPokemonGameVersions(name: String) async {
        isLoading = true

        errorMessage = await ErrorHandler.handleFetching {
            let gameVersions = try await pokemonGameVersionsUseCase.execute(name: name)

            self.pokemonGameVersions = gameVersions
        }
        showAlert = errorMessage != nil
        isLoading = false
    }
}
