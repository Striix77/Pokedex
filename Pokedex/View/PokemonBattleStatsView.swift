//
//  PokemonBattleStatsView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct PokemonBattleStatsView: View {
    let pokemonHP: Int
    let pokemonAttack: Int
    let pokemonDefense: Int
    let pokemonSpeed: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Base Stats")
                .font(.title2)
                .bold()

            StatBar(
                label: "HP",
                value: pokemonHP,
                color: .green
            )
            StatBar(
                label: "ATK",
                value: pokemonAttack,
                color: .red
            )
            StatBar(
                label: "DEF",
                value: pokemonDefense,
                color: .blue
            )
            StatBar(
                label: "SPD",
                value: pokemonSpeed,
                color: .orange
            )
        }
        .padding()
    }
}
