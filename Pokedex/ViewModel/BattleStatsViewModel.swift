//
//  BattleStatsViewModel.swift
//  Pokedex
//
//  Created by Freak on 08.04.2026.
//
import SwiftUI

struct BattleStatsCalculator {
    let pokemonTypes: [PokemonTypes]
    let allTypes: [PokemonType]

    private var pokemonTypesWithEfficacies: [PokemonType] {
        var typesWithEfficacies: [PokemonType] = []
        pokemonTypes.forEach { type in
            typesWithEfficacies.append(
                contentsOf:
                    allTypes.filter {
                        $0.name == type.type.name
                    }
            )
        }
        return typesWithEfficacies
    }

    func calculateEfficacies(for strength: Int) -> [(String, Int)] {
        var typeStrengths: [(String, Int)] = []
        pokemonTypesWithEfficacies.forEach { type in
            typeStrengths.append(
                contentsOf: type.typeEfficaciesByTargetTypeId?
                    .filter {
                        $0.damageFactor == strength
                    }
                    .map {
                        ($0.type.name.capitalized, $0.type.id)
                    } ?? []
            )
        }
        return typeStrengths
    }
}
