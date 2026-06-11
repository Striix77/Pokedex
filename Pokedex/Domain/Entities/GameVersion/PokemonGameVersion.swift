import Foundation

struct PokemonGameVersion: Identifiable, Codable, Hashable {
    let id: Int
    let name: String
    let generation: PokemonGeneration

    var formattedName: String {
        name.split(separator: "-").map { $0.capitalized(with: .none) }.joined(separator: " / ")
    }
}
