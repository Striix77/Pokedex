import Foundation

@Observable
@MainActor
class PokemonEvolutionViewModel {
    var errorMessage: String?
    var showAlert = false
    var evolutionChain: EvolutionChainEntry? = nil

    private let useCase: PokemonEvolutionChainUseCaseProtocol

    init(useCase: PokemonEvolutionChainUseCaseProtocol) {
        self.useCase = useCase
    }

    func fetchEvolutionChain(pokemonName: String) async {
        errorMessage = await ErrorHandler.handleFetching {
            self.evolutionChain = try await self.useCase.execute(pokemonName: pokemonName)
        }
        showAlert = errorMessage != nil
    }
}
