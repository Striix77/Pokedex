//
//  PokemonStatsTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonStatsTab: View {
    let details: PokemonDetailsEntry
    let accentColor: Color

    var body: some View {
        VStack {
            HexStatGrid(stats: details.stats, accentColor: accentColor)
                .padding(20)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .border(.red)
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
