import Foundation

@Observable
@MainActor
class PokemonMovesViewModel {
    var areVersionsLoading = true
    var areMovesLoading = true
    var errorMessage: String?
    var showVersionsAlert: Bool = false
    var showMovesAlert: Bool = false
    var pokemonGameVersions: [PokemonGameVersion] = []
    var pokemonMoves: [PokemonMoveEntry] = []

    private let pokemonGameVersionsUseCase: PokemonGameVersionsUseCaseProtocol
    private let pokemonMovesUseCase: PokemonMovesUseCaseProtocol

    init(
        pokemonGameVersionsUseCase: PokemonGameVersionsUseCaseProtocol,
        pokemonMovesUseCase: PokemonMovesUseCaseProtocol
    ) {
        self.pokemonGameVersionsUseCase = pokemonGameVersionsUseCase
        self.pokemonMovesUseCase = pokemonMovesUseCase
    }

    func fetchPokemonGameVersions(name: String) async {
        areVersionsLoading = true

        errorMessage = await ErrorHandler.handleFetching {
            self.pokemonGameVersions = try await self.pokemonGameVersionsUseCase.execute(name: name)
        }
        showVersionsAlert = errorMessage != nil
        areVersionsLoading = false
    }

    func fetchMoves(name: String, versionGroupName: String) async {
        areMovesLoading = true

        errorMessage = await ErrorHandler.handleFetching {
            self.pokemonMoves = try await self.pokemonMovesUseCase.execute(
                name: name,
                versionGroupName: versionGroupName
            )
        }
        showMovesAlert = errorMessage != nil
        areMovesLoading = false
    }
}
