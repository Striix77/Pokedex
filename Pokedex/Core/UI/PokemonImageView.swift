//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import SwiftUI
import Kingfisher

struct PokemonImageView: View {
    @State private var didFail = false
    @State private var isLoading = true
    @State private var showContent = false
    let spriteURL: URL?

    private let fadeDuration = 0.5

    var body: some View {
        ZStack {
            if didFail {
                placeholder
            } else {
                if !showContent {
                    progressView
                }
                pokemonImage
            }
        }
        .padding(.top, 30)
    }

    private var placeholder: some View {
        Image("missingno")
            .resizable()
            .scaledToFit()
    }

    private var progressView: some View {
        ZStack {
            GeometryReader { geo in
                PokeballProgressView(isLoading: $isLoading) {
                    showContent = true
                }
                .frame(width: geo.size.width / 2)
                .position(
                    x: geo.size.width / 2,
                    y: geo.size.height / 2
                )
                .transition(.opacity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var pokemonImage: some View {
        KFImage(spriteURL)
            .onSuccess { result in
                print(
                    "Loaded from: \(result.cacheType == .disk ? "Disk" : "Network")"
                )
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
            .onFailure { error in
                print(
                    "Image failed to load: \(error.localizedDescription)"
                )
                DispatchQueue.main.async {
                    self.didFail = true
                    self.isLoading = false
                }
            }
            .resizable()
            .scaledToFit()
            .opacity(showContent ? 1 : 0)
    }
}

#Preview {
    PokemonImageView(
        spriteURL: URL(
            string:
            "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/39.png"
        )
    )
}
