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

struct EfficacyView: View {
    let title: String
    let efficacies: [(String, Int)]
    private let spacing: Int = 10

    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat(spacing)) {
            Text(title)
                .font(.title2)

                .bold()
            VStack {
                HStack {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(efficacies, id: \.1) { type in
                                HStack {
                                    AsyncImage(url: getIconUrl(for: type.1))
                                    Text(type.0)
                                }
                            }
                        }
                    }.scrollIndicators(.hidden)

                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    func getIconUrl(for id: Int) -> URL? {
        URL(
            string:
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-ix/scarlet-violet/small/\(id).png"
        )
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
