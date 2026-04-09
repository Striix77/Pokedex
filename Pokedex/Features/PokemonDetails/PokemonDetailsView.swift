//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonDetailsView: View {
    @State private var viewModel = DetailsViewModel()
    let pokemonEntry: PokemonListEntry
    let types: [PokemonType]
    let isFavorite: Bool
    let onFavoriteToggle: () -> Void

    private var calculator: BattleStatsCalculator {
        BattleStatsCalculator(
            pokemonTypes: pokemonEntry.pokemontypes,
            allTypes: types
        )
    }

    var body: some View {
        ScrollView {
            if let details = viewModel.pokemonDetails{
                VStack(spacing: 20) {
                    PokemonImageView(spriteURL: details.spriteURL)
                    PokemonInfoHeaderView(
                        id: pokemonEntry.id,
                        name: pokemonEntry.name,
                        onFavoriteToggle: onFavoriteToggle,
                        isFavorite: isFavorite,
                        formattedGeneration: pokemonEntry.formattedGeneration,
                        pokemonName: pokemonEntry.name
                    )
                    PokemonStatsView(
                        typeString: pokemonEntry.typeString,
                        weight: details.weight,
                        height: details.height
                    )
                    PokemonBattleStatsView(
                        pokemonHP: details.statValue(named: "hp"),
                        pokemonAttack: details.statValue(
                            named: "attack"
                        ),
                        pokemonDefense: details.statValue(
                            named: "defense"
                        ),
                        pokemonSpeed: details.statValue(
                            named: "speed"
                        ),
                        calculator: calculator
                    )
                    
                    Spacer()
                }
                .padding()
            } else {
                ProgressView()
            }
        }
        .task {
            await viewModel.fetchPokemonDetails(id: pokemonEntry.id)
        }
        .navigationTitle(pokemonEntry.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
    }
}
