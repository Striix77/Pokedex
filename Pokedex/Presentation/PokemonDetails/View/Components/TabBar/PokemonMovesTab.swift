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
        ZStack {
            if viewModel.areVersionsLoading, selectedVersion != nil {
                ProgressView()
                    .frame(maxWidth: .infinity)
            } else {
                contentView
            }
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
        .animation(.easeInOut(duration: Constants.loadingAnimationDuration), value: viewModel.areVersionsLoading)
    }

    private var contentView: some View {
        VStack(spacing: Constants.outerSpacing) {
            gameVersionsContainer
            moveSetViews
        }
        .transition(.blurReplace())
    }

    private var gameVersionsContainer: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack(spacing: Constants.versionButtonSpacing) {
                    ForEach(gameVersions, id: \.id) { gameVersion in
                        gameVersionButton(gameVersion, isSelected: selectedVersion == gameVersion.name)
                    }
                }
                .padding(.vertical)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize, axes: .horizontal)

            ProgressView()
                .opacity(viewModel.areMovesLoading ? 1 : 0)
                .animation(.easeInOut(duration: Constants.movesLoadingAnimationDuration), value: viewModel.areMovesLoading)
        }
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
        .padding(.horizontal, Constants.buttonHorizontalPadding)
        .padding(.vertical, Constants.buttonVerticalPadding)
        .containerBackground(
            cornerRadius: Constants.buttonCornerRadius,
            fill: isSelected ? accentColor.opacity(Constants.buttonSelectedBackgroundOpacity) : Color.containerBackground,
            stroke: isSelected ? accentColor : Color.containerBorder,
            lineWidth: Constants.buttonBorderWidth
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: Constants.selectionAnimationDuration)) {
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

// MARK: - Constants

extension PokemonMovesTab {
    enum Constants {
        static let outerSpacing: CGFloat = 24
        static let versionButtonSpacing: CGFloat = 16
        static let buttonHorizontalPadding: CGFloat = 16
        static let buttonVerticalPadding: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 22
        static let buttonBorderWidth: CGFloat = 1
        static let buttonSelectedBackgroundOpacity: Double = 0.2
        static let selectionAnimationDuration: Double = 0.3
        static let loadingAnimationDuration: Double = 0.5
        static let movesLoadingAnimationDuration: Double = 0.1
    }
}

#Preview("Bulbasaur") {
    NavigationStack {
        PokemonDetailsView(
            pokemonListEntry: .mockBulbasaur,
            types: PokemonType.mockBulbasaurTypes
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
