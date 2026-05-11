//
//  PokemonDetailsView.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonDetailsView: View {
    @State private var viewModel = PokemonDetailsViewModel(
        pokemonDetailsUseCase: PokemonDetailsUseCase(
            apiService: PokemonDetailsAPIService()
        )
    )
    @Environment(\.colorScheme) private var colorScheme
    let pokemonListEntry: PokemonListEntry
    let types: [PokemonType]

    private var calculator: BattleStatsCalculator {
        BattleStatsCalculator(
            pokemonTypes: pokemonListEntry.pokemontypes,
            allTypes: types
        )
    }

    private var typeColors: (Color?, Color?) {
        TypeColor.getDoubleTypeColors(for: pokemonListEntry, scheme: colorScheme)
    }

    var body: some View {
        ZStack {
            backgroundGradient
        ScrollView {
            if let details = viewModel.pokemonDetails {
                VStack(spacing: 20) {
                    ZStack{
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                        PokemonImageView(spriteURL: details.spriteURL)
                    }
                    PokemonInfoHeaderView(
                        id: pokemonListEntry.id,
                        formattedGeneration: pokemonListEntry
                            .formattedGeneration,
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
        }
        .task {
            await viewModel.fetchPokemonDetails(id: pokemonListEntry.id)
        }
        .navigationTitle(pokemonListEntry.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
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

