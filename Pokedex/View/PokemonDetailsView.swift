//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonDetailsView: View {
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

    var body: some View {
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
