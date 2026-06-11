import SwiftUI

struct MoveCard: View {
    let move: PokemonMoveEntry
    let accentColor: Color

    var body: some View {
        HStack {
            Text(move.move.formattedName)
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
