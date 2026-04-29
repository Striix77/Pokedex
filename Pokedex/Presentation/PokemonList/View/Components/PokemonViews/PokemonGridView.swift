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
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    var body: some View {
        VStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(allPokemon) { pokemon in
                        NavigationLink(value: pokemon) {
                            PokemonGridCard(pokemon: pokemon)
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
    @State private var ringStopLocation:CGFloat = 0
    @Environment(\.colorScheme) var colorScheme
    let pokemon: PokemonListEntry

    private var typeColors: (Color?, Color?) {
        var colors = TypeColor.getDoubleTypeColors(for: pokemon, scheme: colorScheme)
        colors.0 = colors.0?.opacity(3)
        colors.1 = colors.1?.opacity(3)
        return colors
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(.gray).opacity(0.1)

            GlowingRing(colors: typeColors)
                .padding(12)

            mainContent
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fit)
        .clipped()
    }

    private var mainContent: some View {
        VStack {
            PokemonImageView(spriteURL: pokemon.spriteURL)
                .aspectRatio(1, contentMode: .fit)
                .frame(maxWidth: .infinity)
            Text("#\(pokemon.id)")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(pokemon.name.capitalized)
                .bold()
                .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom)
        .foregroundStyle(Color.mainFont)
    }
}

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
        .task {
            await viewModel.fetchPokemon()
        }
        .environment(SoundManager())
        .environment(FavoritesService())

}
