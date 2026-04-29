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
        GridItem(.adaptive(minimum: 150), spacing: 16),
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
                
            mainContent
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
    }
    
    private var mainContent: some View{
        VStack {
            PokemonImageView(spriteURL: spriteURL)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
            Text("#\(id)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(name)
                .bold()
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
        .foregroundStyle(.white)
struct GlowingRing: View {
    let colors: (Color?, Color?)
    @State private var rotation: Double = 0
    @State private var scale: Double = 0
    @State private var opacity: Double = 1

    var body: some View {
        let color1 = colors.0 ?? .white
        let color2 = colors.1 ?? color1

        Circle()
            .stroke(
                AngularGradient(
                    colors: [color1, color2, color1],
                    center: .center
                ),
                lineWidth: 16
            )
            .blur(radius: 28)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: false)) {
                    rotation = 360
                    scale = 3
                    opacity = 0
                }
            }
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
