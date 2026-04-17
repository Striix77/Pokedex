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
    let calculator: BattleStatsCalculator

    private let strongEfficacyTitle = "Strong against"
    private let weakEfficacyTitle = "Weak against"
    private let strongEfficacyValue = 50
    private let weakEfficacyValue = 200

    private var strengthEfficacies: [TypeStrength]? {
        calculator.calculateEfficacies(
            for: strongEfficacyValue
        )
    }
    private var weaknessEfficacies: [TypeStrength]? {
        calculator.calculateEfficacies(
            for: weakEfficacyValue
        )
    }

    var body: some View {
        VStack {
            PokemonBaseStatsView(
                pokemonHP: pokemonHP,
                pokemonAttack: pokemonAttack,
                pokemonDefense: pokemonDefense,
                pokemonSpeed: pokemonSpeed
            )
            efficacyViews

        }
    }

    private var efficacyViews: some View {
        VStack {
            if let efficacies = strengthEfficacies {
                EfficacyView(
                    title: strongEfficacyTitle,
                    efficacies: efficacies
                )
            } else {
                noEfficacySubview
            }
            if let efficacies = weaknessEfficacies {
                EfficacyView(
                    title: weakEfficacyTitle,
                    efficacies: efficacies
                )
            } else if strengthEfficacies != nil {
                noEfficacySubview
            }
        }
    }
    
    private var noEfficacySubview: some View {
        Text("Other stats to be discovered...")
            .font(.title3)
            .bold()
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(Color(red: 1, green: 0.9373, blue: 0.6588))
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }

}

#Preview(traits: .sizeThatFitsLayout) {
    PokemonBattleStatsView(
        pokemonHP: 100,
        pokemonAttack: 90,
        pokemonDefense: 80,
        pokemonSpeed: 70,
        calculator: BattleStatsCalculator(pokemonTypes: [], allTypes: [])
    )
}
