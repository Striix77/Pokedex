import SDWebImageSwiftUI
//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import SwiftUI

struct PokemonImageView: View {
    @State private var didFail = false
    @State private var isLoading = true
    let spriteURL: URL?

    private let fadeDuration = 0.5

    var body: some View {
        ZStack {
            if didFail {
                Image("missingno")
                    .resizable()
                    .scaledToFit()
            } else {
                //TODO: Replace with Kingfisher
                WebImage(url: spriteURL)
                    .onSuccess { image, data, cacheType in
                        print(
                            "Loaded from: \(cacheType == .disk ? "Disk" : "Network")"
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
                    .indicator { isAnimating, progress in
                        ZStack {
                            GeometryReader { geo in
                                PokeballProgressView()
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
                    .scaledToFit()
                    .animation(
                        .easeInOut(duration: fadeDuration),
                        value: isLoading
                    )

            }
        }
        .padding(.top, 30)
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
