//
//  PokemonImageView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//
import SwiftUI
import SDWebImageSwiftUI

struct PokemonImageView: View {
    @State private var didFail = false
    let spriteURL: URL?
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.blue.opacity(0.1))
                .frame(width: 260, height: 260)

            if didFail {
                Image("missingno")
                    .resizable()
                    .frame(width: 250, height: 250)
            } else {
                WebImage(url: spriteURL)
                    .onSuccess { image, data, cacheType in
                        print(
                            "Loaded from: \(cacheType == .disk ? "Disk" : "Network")"
                        )
                    }
                    .onFailure { error in
                        print(
                            "Image failed to load: \(error.localizedDescription)"
                        )
                        DispatchQueue.main.async {
                            self.didFail = true
                        }
                    }
                    .resizable()
                    .indicator(.activity)
                    .frame(width: 250, height: 250)
            }

        }
        .padding(.top, 30)
    }
}
