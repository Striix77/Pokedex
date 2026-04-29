//
//  PokemonGridView.swift
//  Pokedex
//
//  Created by Freak on 29.04.2026.
//

import SwiftUI

struct PokemonGridView: PokemonViewProtocol {
    let allPokemon: [PokemonListEntry]
    let typeList: [PokemonType]

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allPokemon) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonGridCard(
                                id:pokemon.id,
                                name: pokemon.name.capitalized,
                                spriteURL: pokemon.spriteURL
                            )
                        }
                    }
                }
                .padding()
            }
            .scrollContentBackground(.hidden)
            .navigationDestination(for: PokemonListEntry.self) {
                pokemonListEntry in
                PokemonDetailsView(
                    pokemonListEntry: pokemonListEntry,
                    types: typeList
                )
            }
        }
    }
}

struct PokemonGridCard: View {
    let id: Int
    let name: String
    let spriteURL: URL?
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8)
                .fill(.ultraThinMaterial)
                
            VStack {
                PokemonImageView(spriteURL: spriteURL)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: .infinity)
                Text("\(id)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(name)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    @Previewable @State var viewModel = PokedexViewModel(
        pokemonListDataUseCase: PokemonListDataUseCase(
            apiService: PokemonListAPIService()
        ),
        filteringService: FilteringService()
    )
    NavigationStack {
        PokemonGridView(
            allPokemon: viewModel.filteredPokemon,
            typeList: viewModel.typeList
        )
        .task {
            await viewModel.fetchPokemon()
        }
    }

}

#Preview("Pokedex") {
    @Previewable @State var viewModel = PokedexViewModel(
        pokemonListDataUseCase: PokemonListDataUseCase(
            apiService: PokemonListAPIService()
        ),
        filteringService: FilteringService()
    )
    PokedexView(viewModel: viewModel)
        .task{
            await viewModel.fetchPokemon()
        }
        .environment(SoundManager())
        .environment(FavoritesService())
    
}
