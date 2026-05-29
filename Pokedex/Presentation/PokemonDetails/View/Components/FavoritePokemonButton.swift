//
//  FavoritePokemonButton.swift
//  Pokedex
//
//  Created by Freak on 29.05.2026.
//
import SwiftUI

struct FavoritePokemonButton: View {
    @Environment(\.favoritesService) var favoritesManager
    let id: Int

    private var isFavorite: Bool {
        favoritesManager.favoriteIDs.contains(id)
    }

    var body: some View {
        Button {
            favoritesManager.toggle(id)
        } label: {
            Image(
                systemName: isFavorite
                    ? "heart.fill" : "heart"
            )
            .font(.system(size: 30))
            .foregroundStyle(isFavorite ? .red : .gray)
        }
        .buttonStyle(.borderless)
    }
}

#Preview {
    FavoritePokemonButton(id: 1)
}
