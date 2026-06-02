//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import Kingfisher
import SwiftUI

struct PokemonImageView: View {
    @State private var didFail = false
    let spriteURL: URL?

    var body: some View {
        ZStack {
            if didFail {
                Image("missingno")
                    .resizable()
                    .scaledToFit()
            } else {
                KFImage(spriteURL)
                    .onSuccess { result in
                        print(
                            "Loaded from: \(result.cacheType == .disk ? "Disk" : "Network")"
                        )
                    }
                    .onFailure { error in
                        print(
                            "Image failed to load: \(error.localizedDescription)"
                        )
                        self.didFail = true
                    }
                    .resizable()
                    .placeholder {
                        ProgressView()
                    }
                    .scaledToFit()
            }
        }
        .padding(.top, 30)
    }
}
