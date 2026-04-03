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

    var body: some View {
        VStack {
            PokemonBaseStatsView(
                pokemonHP: pokemonHP,
                pokemonAttack: pokemonAttack,
                pokemonDefense: pokemonDefense,
                pokemonSpeed: pokemonSpeed
            )
            VStack(alignment: .leading, spacing: 10) {
                Text("Strong against")
                    .font(.title2)

                    .bold()
                VStack {
                    HStack {
                        ForEach(calculateStrengths(), id: \.1) { type in
                            HStack {
                                AsyncImage(url: getIconUrl(for: type.1))
                                Text(type.0)
                            }
                        }

                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }

    func getIconUrl(for id: Int) -> URL? {
        URL(
            string:
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-ix/scarlet-violet/small/\(id).png"
        )
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

    func calculateStrengths() -> [(String, Int)] {
        var typeStrengths: [(String, Int)] = []
        getPokemonTypesWithEfficacies().forEach { type in
            typeStrengths.append(
                contentsOf: type.typeEfficaciesByTargetTypeId?
                    .filter {
                        $0.damage_factor == 200
                    }
                    .map {
                        ($0.type.name.capitalized, $0.type.id)
                    } ?? [("", 0)]
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
