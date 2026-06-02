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
    @Environment(\.dismiss) private var dismiss
    let pokemonListEntry: PokemonListEntry
    let types: [PokemonType]

    private let typeColorOpacity = 0.3
    private let progressViewScale: CGFloat = 2
    private let gradientTypeStopLocation = 0.3
    private let gradientFadeStopLocation = 0.6
    private let contentSpacing: CGFloat = 20
    private let contentPadding: CGFloat = 16
    private let transitionAnimationDuration: Double = 0.25

    private var colorSchemeBackground: Color {
        Color.pokemonHeroCardBackground
    }

    private var backgroundColors: (Color, Color) {
        let firstColor = typeColors.0?.opacity(typeColorOpacity) ?? colorSchemeBackground
        let secondColor = typeColors.1?.opacity(typeColorOpacity) ?? firstColor
        return (firstColor, secondColor)
    }

    private var backgroundGradientStops: [Gradient.Stop] {
        [
            Gradient.Stop(color: backgroundColors.0, location: 0),
            Gradient.Stop(color: backgroundColors.1, location: gradientTypeStopLocation),
            Gradient.Stop(color: colorSchemeBackground, location: gradientFadeStopLocation),
            Gradient.Stop(color: colorSchemeBackground, location: 1),
        ]
    }

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
                    .transition(.blurReplace)
            }
        }
        .animation(.easeInOut(duration: transitionAnimationDuration), value: viewModel.isLoading)
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
            .scaleEffect(progressViewScale)
    }

    private var mainContent: some View {
        ScrollView {
            if let details = viewModel.pokemonDetails {
                VStack(spacing: contentSpacing) {
                    PokemonHeroCard(pokemonListEntry: pokemonListEntry, typeColors: typeColors)
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
                .padding(contentPadding)
            }
        }
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                FavoritePokemonButton(id: pokemonListEntry.id)
                    .imageScale(.small)
            }
            .sharedBackgroundVisibility(.hidden)
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            stops: backgroundGradientStops,
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mock,
            types: PokemonType.mockTypes
        )
        .environment(SoundManager())
    }
}

#Preview("Squirtle") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockSquirtle,
            types: PokemonType.mockSquirtleTypes
        )
        .environment(SoundManager())
    }
}
