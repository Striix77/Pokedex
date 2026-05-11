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
                    .indicator{ isAnimating, progress in
                        ZStack{
                            GeometryReader{ geo in
                                PokeballProgressView()
                                    .frame(width: geo.size.width/2)
                                    .position(x: geo.size.width / 2, y: geo.size.height / 2)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .scaledToFit()
                
            }
        }
        .padding(.top, 30)
    }
}

#Preview {
    PokemonImageView(spriteURL: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/3.png"))
}
