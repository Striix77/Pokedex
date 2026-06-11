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
        ),
        pokemonMovesUseCase: PokemonMovesUseCase(
            apiService: PokemonMovesAPIService()
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

    private var levelUpMoves: [PokemonMoveEntry] {
        viewModel.pokemonMoves.filter { $0.moveLearnType == .levelUp }
    }

    private var tmMoves: [PokemonMoveEntry] {
        viewModel.pokemonMoves.filter { $0.moveLearnType == .tm }
    }

    private var hmMoves: [PokemonMoveEntry] {
        viewModel.pokemonMoves.filter { $0.moveLearnType == .hm }
    }

    private var eggMoves: [PokemonMoveEntry] {
        viewModel.pokemonMoves.filter { $0.moveLearnType == .egg }
    }

    var body: some View {
        VStack(spacing: 24) {
            gameVersionsContainer

            moveSetViews
        }
        .task {
            await fetchVersions()
        }
        .fetchingAlert(
            showAlert: $viewModel.showVersionsAlert,
            fetchAction: {
                await fetchVersions()
            },
            confirmAction: { dismiss() },
            errorMessage: viewModel.errorMessage
        )
        .task(id: selectedVersion) {
            guard let version = selectedVersion else { return }
            await viewModel.fetchMoves(name: pokemonName, versionGroupName: version)
        }
        .fetchingAlert(
            showAlert: $viewModel.showMovesAlert,
            fetchAction: {
                await fetchVersions()
            },
            confirmAction: { dismiss() },
            errorMessage: viewModel.errorMessage
        )
    }

    private var gameVersionsContainer: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 16) {
                ForEach(gameVersions, id: \.id) { gameVersion in
                    gameVersionButton(gameVersion, isSelected: selectedVersion == gameVersion.name)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
    }

    private var moveSetViews: some View {
        VStack(alignment: .leading) {
            MoveSetView(moveSet: levelUpMoves, title: moveSetTitle(moves: levelUpMoves), accentColor: accentColor)

            MoveSetView(moveSet: tmMoves, title: moveSetTitle(moves: tmMoves), accentColor: accentColor)

            if !hmMoves.isEmpty {
                MoveSetView(moveSet: hmMoves, title: moveSetTitle(moves: hmMoves), accentColor: accentColor)
            }

            if !eggMoves.isEmpty {
                MoveSetView(moveSet: eggMoves, title: moveSetTitle(moves: eggMoves), accentColor: accentColor)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
        .containerBackground(
            cornerRadius: buttonCornerRadius,
            fill: isSelected ? accentColor.opacity(buttonSelectedBackgroundOpacity) : Color.containerBackground,
            stroke: isSelected ? accentColor : Color.containerBorder,
            lineWidth: buttonBorderWidth
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: animationDuration)) {
                selectedVersion = gameVersion.name
            }
        }
    }

    private func fetchVersions() async {
        await viewModel.fetchPokemonGameVersions(name: pokemonName)
        selectedVersion = gameVersions.first?.name
    }

    private func moveSetTitle(moves: [PokemonMoveEntry]) -> String {
        moves.first?.moveLearnType.label ?? "Other"
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
