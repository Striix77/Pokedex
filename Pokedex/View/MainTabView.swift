//
//  MainTabView.swift
//  Pokedex
//
//  Created by Freak on 26.02.2026.
//

import SwiftUI

struct MainTabView: View {
    @State private var viewModel = PokemonListViewModel()

    var body: some View {
        TabView {
            PokemonListView(viewModel: viewModel)
                .tabItem {
                    Label("All Pokémon", systemImage: "bolt.fill")
                }
            FavoritesView(viewModel: viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

#Preview {
    MainTabView()
}
