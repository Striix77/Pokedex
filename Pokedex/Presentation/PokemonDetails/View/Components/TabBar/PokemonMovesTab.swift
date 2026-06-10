//
//  PokemonMovesTab.swift
//  Pokedex
//
//  Created by Freak on 08.06.2026.
//
import SwiftUI

struct PokemonMovesTab: View {
    @State private var viewModel = PokemonMovesViewModel(pokemonGameVersionsUseCase: PokemonGameVersionsUseCase(apiService: PokemonGameVersionsAPIService()))
    @Environment(\.dismiss) var dismiss
    
    let pokemonName: String
    var body: some View {
        ScrollView(.horizontal){
            HStack{
                ForEach(viewModel.pokemonGameVersions, id: \.id) {gameVersion in
                    Text(gameVersion.formattedName)
                }
            }
        }
        .task{
            await viewModel.fetchPokemonGameVersions(name: pokemonName)
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

