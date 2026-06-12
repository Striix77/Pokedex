import SwiftUI

@Observable
final class MoveSelectionState {
    var presentedMove: PokemonMoveEntry? = nil
    var highlightedMoveId: Int? = nil
    var tapOffset: CGSize = .zero
    private var isClosing = false
    private var pendingMove: (PokemonMoveEntry, CGSize)? = nil

    func select(_ move: PokemonMoveEntry, offset: CGSize) {
        if isClosing {
            pendingMove = (move, offset)
            highlightedMoveId = move.id
            return
        }
        tapOffset = offset
        highlightedMoveId = move.id
        presentedMove = move
    }

    func startClose() {
        isClosing = true
        highlightedMoveId = nil
    }

    func didClose() {
        isClosing = false
        presentedMove = nil
        if let (move, offset) = pendingMove {
            pendingMove = nil
            select(move, offset: offset)
        }
    }
}
