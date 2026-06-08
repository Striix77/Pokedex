//
//  PokemonAboutTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonAboutTab: View {
    let pokemonListEntry: PokemonListEntry
    let types: [PokemonType]
    let details: PokemonDetailsEntry

    private var calculator: BattleStatsCalculator {
        BattleStatsCalculator(
            pokemonTypes: pokemonListEntry.pokemontypes,
            allTypes: types
        )
    }

    var body: some View {
        PokemonStatsView(
            weight: details.weight,
            height: details.height,
            category: details.pokemonspecy?.genus
        )
        PokemonBattleStatsView(
            pokemonHP: details.statValue(named: "hp"),
            pokemonAttack: details.statValue(
                named: "attack"
            ),
            pokemonDefense: details.statValue(
                named: "defense"
            ),
            pokemonSpeed: details.statValue(named: "speed"),
            calculator: calculator
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
