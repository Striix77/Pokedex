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

    private let title = "Base Stats"
    private let hpLabel = "HP"
    private let attackLabel = "ATK"
    private let defenseLabel = "DEF"
    private let speedLabel = "SPD"

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.title2)
                .bold()

            StatBarView(
                label: hpLabel,
                value: pokemonHP,
                color: .green
            )
            StatBarView(
                label: attackLabel,
                value: pokemonAttack,
                color: .red
            )
            StatBarView(
                label: defenseLabel,
                value: pokemonDefense,
                color: .blue
            )
            StatBarView(
                label: speedLabel,
                value: pokemonSpeed,
                color: .orange
            )
        }
        .padding()
    }
}
