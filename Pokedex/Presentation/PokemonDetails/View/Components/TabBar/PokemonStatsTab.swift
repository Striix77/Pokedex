//
//  PokemonStatsTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonStatsTab: View {
    let details: PokemonDetailsEntry
    var body: some View {
        PokemonBattleStatsView(
            pokemonHP: details.statValue(named: "hp"),
            pokemonAttack: details.statValue(named: "attack"),
            pokemonDefense: details.statValue(named: "defense"),
            pokemonSpeed: details.statValue(named: "speed")
        )
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
