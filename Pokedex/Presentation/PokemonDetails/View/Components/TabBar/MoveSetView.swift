import SwiftUI

struct MoveSetView: View {
    let moveSet: [PokemonMoveEntry]
    let title: String
    let accentColor: Color
    let onMoveTap: (PokemonMoveEntry, CGSize) -> Void

    var body: some View {
        moveTypeTitle(title, count: moveSet.count)

        moveList
    }

    private func moveTypeTitle(_ title: String, count: Int) -> some View {
        HStack {
            Text(title)
                .font(.title2)
                .fontDesign(.rounded)
                .bold()

            Text("\(count)")
                .font(.title3)
                .fontDesign(.rounded)
                .bold()
                .foregroundStyle(accentColor)
        }
    }

    private var moveList: some View {
        VStack(alignment: .center) {
            ForEach(moveSet, id: \.id) { move in
                MoveCard(move: move, accentColor: accentColor, onTap: onMoveTap)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mock,
            types: PokemonType.mockTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Squirtle") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockSquirtle,
            types: PokemonType.mockSquirtleTypes
        )
        .environment(SoundManager())
    }
}
