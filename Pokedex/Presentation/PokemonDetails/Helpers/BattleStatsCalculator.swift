//
//  BattleStatsCalculator.swift
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
        for type in pokemonTypes {
            typesWithEfficacies.append(
                contentsOf:
                allTypes.filter {
                    $0.name == type.type.name
                }
            )
        }
        return typesWithEfficacies
    }

    func calculateEfficacies(for strengths: [Int]) -> [TypeStrength]? {
        var typeStrengths: [TypeStrength] = []
        for strength in strengths {
            for type in pokemonTypesWithEfficacies {
                typeStrengths.append(
                    contentsOf: type.typeEfficaciesByTargetTypeId?
                        .filter {
                            $0.damageFactor == strength
                                && !typeStrengths.contains(
                                    TypeStrength(
                                        name: $0.type.name.capitalized,
                                        id: $0.type.id
                                    )
                                )
                        }
                        .map {
                            TypeStrength(
                                name: $0.type.name.capitalized,
                                id: $0.type.id
                            )
                        } ?? []
                )
            }
        }
        return !typeStrengths.isEmpty ? typeStrengths : nil
    }
}
