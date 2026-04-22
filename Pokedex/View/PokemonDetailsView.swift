//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonDetailsView: View {
    @Environment(\.colorScheme) private var colorScheme
    let pokemon: Pokemon
    let types: [PokemonType]
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void

    private var calculator: BattleStatsCalculator {
        BattleStatsCalculator(
            pokemonTypes: pokemon.pokemontypes,
            allTypes: types
        )
    }

    private var typeColors: (Color?, Color?) {
        TypeColor.getDoubleTypeColors(for: pokemon)
    }

    var body: some View {
        ZStack {
            backgroundGradient
            ScrollView {
                VStack(spacing: 20) {
                    PokemonImageView(spriteURL: pokemon.spriteURL)
                    PokemonInfoHeaderView(
                        id: pokemon.id,
                        onFavoriteToggle: onFavoriteToggle,
                        isFavorite: isFavorite,
                        formattedGeneration: pokemon.formattedGeneration,
                        pokemonName: pokemon.name
                    )
                    PokemonStatsView(
                        typeString: pokemon.typeString,
                        weight: pokemon.weight,
                        height: pokemon.height
                    )
                    PokemonBattleStatsView(
                        pokemonHP: pokemon.statValue(named: "hp"),
                        pokemonAttack: pokemon.statValue(named: "attack"),
                        pokemonDefense: pokemon.statValue(named: "defense"),
                        pokemonSpeed: pokemon.statValue(named: "speed"),
                        calculator: calculator
                    )

                    Spacer()
                }
                .padding()
            }
            .navigationTitle(pokemon.name.capitalized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .tabBar)
        }
    }

    private var backgroundGradient: some View {
        var backgroundColors: (Color, Color)
        let colorSchemeBackground = colorScheme == .light ? Color.white : Color.black
        backgroundColors.0 = typeColors.0 ?? colorSchemeBackground
        backgroundColors.1 = typeColors.1 ?? colorSchemeBackground
        return LinearGradient(
            colors: [
                backgroundColors.0, backgroundColors.1,
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
}

#Preview {
    PokemonDetailsView(
        pokemon: Pokemon.mock(id: 7, name: "Squirtle"),
        types: [
            PokemonType(
                id: 11,
                name: "water",
                typeEfficaciesByTargetTypeId: nil
            )
        ],
        isFavorite: false,
        onFavoriteToggle: {}
         
    )
}
