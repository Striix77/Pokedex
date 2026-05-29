//
//  FavoritePokemonButton.swift
//  Pokedex
//
//  Created by Freak on 29.05.2026.
//
import SwiftUI

struct FavoritePokemonButton: View {
    @Environment(\.favoritesService) var favoritesManager
    @State private var overlayScale: CGFloat = 1
    @State private var overlayOpacity: Double = 1
    @State private var animationDuration: Double = 0.5

    let id: Int

    private let finalOverlayScale: CGFloat = 3
    private let finalOverlayOpacity: Double = 0
    private let initialOverlayScale: CGFloat = 1
    private let initialOverlayOpacity: Double = 1

    private var isFavorite: Bool {
        favoritesManager.favoriteIDs.contains(id)
    }

    var body: some View {
        Image(
            systemName: isFavorite
                ? "heart.fill" : "heart"
        )
        .font(.system(size: 30))
        .foregroundStyle(isFavorite ? Color.accentColor : .gray)
        .overlay(
            Image(systemName: "heart")
                .font(.system(size: 30))
                .foregroundStyle(isFavorite ? Color.accentColor : .gray)
                .scaleEffect(overlayScale)
                .opacity(overlayOpacity)
        )
        .onTapGesture {
            withAnimation(.easeInOut(duration: animationDuration)) {
                if !isFavorite {
                    overlayScale = finalOverlayScale
                    overlayOpacity = finalOverlayOpacity
                }
                favoritesManager.toggle(id)
            } completion: {
                overlayScale = initialOverlayScale
                overlayOpacity = initialOverlayOpacity
            }
        }
    }
}

#Preview {
    FavoritePokemonButton(id: 1)
}
