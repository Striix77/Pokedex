//
//  PokemonMovesTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonMovesTab: View {
    @State private var viewModel = PokemonMovesViewModel(
        pokemonGameVersionsUseCase: PokemonGameVersionsUseCase(
            apiService: PokemonGameVersionsAPIService()
        )
    )
    @Environment(\.dismiss) var dismiss
    @State private var selectedVersion: String? = nil

    let pokemonName: String
    let accentColor: Color

    private let buttonHorizontalPadding: CGFloat = 16
    private let buttonVerticalPadding: CGFloat = 12
    private let buttonCornerRadius: CGFloat = 22
    private let buttonBorderWidth: CGFloat = 1
    private let buttonSelectedBackgroundOpacity: CGFloat = 0.2
    private let animationDuration: CGFloat = 0.3

    private var gameVersions: [PokemonGameVersion] {
        viewModel.pokemonGameVersions
    }

    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(gameVersions, id: \.id) { gameVersion in
                    gameVersionButton(gameVersion, isSelected: selectedVersion == gameVersion.name)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        .task {
            await viewModel.fetchPokemonGameVersions(name: pokemonName)
            selectedVersion = gameVersions.first?.name
        }
        .fetchingAlert(
            showAlert: $viewModel.showAlert,
            fetchAction: {
                await viewModel.fetchPokemonGameVersions(name: pokemonName)
            },
            confirmAction: { dismiss() },
            errorMessage: viewModel.errorMessage
        )
    }

    private func gameVersionButton(_ gameVersion: PokemonGameVersion, isSelected: Bool) -> some View {
        VStack {
            Text(gameVersion.formattedName)
                .foregroundStyle(isSelected ? .primary : .secondary)
                .bold()

            Text(gameVersion.generation.formattedName)
                .foregroundStyle(isSelected ? accentColor : .secondary.opacity(0.9))
                .font(.caption)
                .bold()
        }
        .padding(.horizontal, buttonHorizontalPadding)
        .padding(.vertical, buttonVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(isSelected ? accentColor.opacity(buttonSelectedBackgroundOpacity) : Color.containerBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: buttonCornerRadius)
                        .stroke(isSelected ? accentColor : Color.containerBorder, lineWidth: buttonBorderWidth)
                )
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: animationDuration)) {
                selectedVersion = gameVersion.name
            }
        }
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
