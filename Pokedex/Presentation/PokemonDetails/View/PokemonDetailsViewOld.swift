//
//  PokemonDetailsViewOld.swift
//  Pokedex
//
//  Created by Freak on 25.02.2026.
//

import SwiftUI

struct PokemonDetailsViewOld: View {
    @State private var viewModel = PokemonDetailsViewModel(
        pokemonDetailsUseCase: PokemonDetailsUseCase(
            apiService: PokemonDetailsAPIService()
        )
    )
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    let pokemonListEntry: PokemonListEntry
    let types: [PokemonType]

    private var calculator: BattleStatsCalculator {
        BattleStatsCalculator(
            pokemonTypes: pokemonListEntry.pokemontypes,
            allTypes: types
        )
    }

    private var typeColors: (Color?, Color?) {
        TypeColor.getDoubleTypeColors(
            for: pokemonListEntry,
            scheme: colorScheme
        )
    }

    var body: some View {
        ZStack {
            backgroundGradient
            if viewModel.isLoading {
                progressView
            } else {
                mainContent
            }
        }
        .task {
            await viewModel.fetchPokemonDetails(id: pokemonListEntry.id)
        }
        .navigationTitle(pokemonListEntry.name.capitalized)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(.hidden, for: .tabBar)
        .fetchingAlert(
            showAlert: $viewModel.showAlert,
            fetchAction: {
                await viewModel.fetchPokemonDetails(id: pokemonListEntry.id)
            },
            confirmAction: { dismiss() },
            errorMessage: viewModel.errorMessage
        )
    }

    private var progressView: some View {
        ProgressView()
            .progressViewStyle(.circular)
            .scaleEffect(2)
    }

    private var mainContent: some View {
        ScrollView {
            if let details = viewModel.pokemonDetails {
                VStack(spacing: 20) {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(maxWidth: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                        PokemonImageView(spriteURL: pokemonListEntry.spriteURL)
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
                        pokemonAttack: details.statValue(
                            named: "attack"
                        ),
                        pokemonDefense: details.statValue(
                            named: "defense"
                        ),
                        pokemonSpeed: details.statValue(named: "speed"),
                        calculator: calculator
                    )
                }
                .padding()
            }
        }
    }

    private var backgroundGradient: some View {
        var backgroundColors: (Color, Color)
        let colorSchemeBackground =
            colorScheme == .light ? Color.white : Color.black
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
