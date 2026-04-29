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
                    .scaledToFit()
            }

        }
        .padding(.top, 30)
    }
}
