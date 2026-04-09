//
//  PokemonBattleStatsView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct PokemonBaseStatsView: View {
    let pokemonHP: Int
    let pokemonAttack: Int
    let pokemonDefense: Int
    let pokemonSpeed: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Base Stats")
                .font(.title2)
                .bold()

            StatBarView(
                label: "HP",
                value: pokemonHP,
                color: .green
            )
            StatBarView(
                label: "ATK",
                value: pokemonAttack,
                color: .red
            )
            StatBarView(
                label: "DEF",
                value: pokemonDefense,
                color: .blue
            )
            StatBarView(
                label: "SPD",
                value: pokemonSpeed,
                color: .orange
            )
        }
        .padding()
    }
}
