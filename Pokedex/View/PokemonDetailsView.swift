//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonDetailsView: View {
    @State private var viewModel = PokemonDetailsViewModel()
    let pokemonListEntry: PokemonListEntry
    
    let types: [PokemonType]
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void

    private var calculator: BattleStatsCalculator {
        BattleStatsCalculator(
            pokemonTypes: pokemonListEntry.pokemontypes,
            allTypes: types
        )
    }

    var body: some View {
        ScrollView {
            if let details = viewModel.pokemonDetails {
                VStack(spacing: 20) {
                    PokemonImageView(spriteURL: details.spriteURL)
                    PokemonInfoHeaderView(
                        id: pokemonListEntry.id,
                        onFavoriteToggle: onFavoriteToggle,
                        isFavorite: isFavorite,
                        formattedGeneration: pokemonListEntry.formattedGeneration,
                        pokemonName: pokemonListEntry.name
                    )
                    PokemonStatsView(
                        typeString: pokemonListEntry.typeString,
                        weight: details.weight,
                        height: details.height
                    )
                    PokemonBattleStatsView(
                        pokemonHP: details.statValue(named: "hp"),
                        pokemonAttack: details.statValue(named: "attack"),
                        pokemonDefense: details.statValue(named: "defense"),
                        pokemonSpeed: details.statValue(named: "speed"),
                        calculator: calculator
                    )
                    
                    Spacer()
                }
                .padding()
            }
        }
        .task{
            await viewModel.fetchPokemonDetails(id: pokemonListEntry.id)
        }
        .navigationTitle(pokemonListEntry.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
