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
    let pokemonTypes: [PokemonTypes]
    let allTypes: [PokemonType]
    
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
                efficacies: calculateEfficacies(for: strongEfficacyValue)
            )
            EfficacyView(
                title: weakEfficacyTitle,
                efficacies: calculateEfficacies(for: weakEfficacyValue)
            )

        }
    }

    func getPokemonTypesWithEfficacies() -> [PokemonType] {
        var pokemonTypesWithEfficacies: [PokemonType] = []
        pokemonTypes.forEach { type in
            pokemonTypesWithEfficacies.append(
                contentsOf:
                    allTypes.filter {
                        $0.name == type.type.name
                    }
            )
        }
        return pokemonTypesWithEfficacies
    }

    func calculateEfficacies(for strength: Int) -> [TypeStrength] {
        var typeStrengths: [TypeStrength] = []
        getPokemonTypesWithEfficacies().forEach { type in
            typeStrengths.append(
                contentsOf: type.typeEfficaciesByTargetTypeId?
                    .filter {
                        $0.damage_factor == strength
                    }
                    .map {
                        TypeStrength(name:$0.type.name.capitalized,id: $0.type.id)
                    } ?? [TypeStrength(name:"", id:0)]
            )
        }
        return typeStrengths
    }
}



#Preview(traits: .sizeThatFitsLayout) {
    PokemonBattleStatsView(
        pokemonHP: 100,
        pokemonAttack: 90,
        pokemonDefense: 80,
        pokemonSpeed: 70,
        pokemonTypes: [],
        allTypes: []
    )
}
