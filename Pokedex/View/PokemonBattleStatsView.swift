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
    

    var body: some View {
        VStack {
            PokemonBaseStatsView(
                pokemonHP: pokemonHP,
                pokemonAttack: pokemonAttack,
                pokemonDefense: pokemonDefense,
                pokemonSpeed: pokemonSpeed
            )

            EfficacyView(
                title: strongEfficacyTitle,
                efficacies: calculator.calculateEfficacies(for: strongEfficacyValue)
            )
            EfficacyView(
                title: weakEfficacyTitle,
                efficacies: calculator.calculateEfficacies(for: weakEfficacyValue)
            )

        }
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
