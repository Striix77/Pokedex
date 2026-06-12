import SwiftUI

@Observable
final class MoveSelectionState {
    var presentedMove: PokemonMoveEntry? = nil
    var highlightedMoveId: Int? = nil
    var tapOffset: CGSize = .zero

    func select(_ move: PokemonMoveEntry, offset: CGSize) {
        tapOffset = offset
        highlightedMoveId = move.id
        presentedMove = move
    }

    func startClose() {
        highlightedMoveId = nil
    }

    func didClose() {
        presentedMove = nil
    }
}
