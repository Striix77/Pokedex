//
//  BattleStatsViewModel.swift
//  Pokedex
//
//  Created by Freak on 08.04.2026.
//
import Foundation

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

    func calculateEfficacies(for strength: Int) -> [TypeStrength] {
            var typeStrengths: [TypeStrength] = []
            pokemonTypesWithEfficacies.forEach { type in
                typeStrengths.append(
                    contentsOf: type.typeEfficaciesByTargetTypeId?
                        .filter {
                            $0.damageFactor == strength && !typeStrengths.contains                       (TypeStrength(name:$0.type.name.capitalized, id: $0.type.id))
                        }
                        .map {
                            TypeStrength(name:$0.type.name.capitalized,id: $0.type.id)
                        } ?? []
                )
            }
            return typeStrengths
        }
}
