//
//  PokemonStatsView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct PokemonStatsView: View {
    let typeString: String
    let weight: Int
    let height: Int

    var body: some View {
        HStack(spacing: 40) {
            StatView(
                label: "Type",
                value: typeString,
                color: .orange
            )
            StatView(
                label: "Weight",
                value: "\(weight)",
                color: .blue
            )
            StatView(
                label: "Height",
                value: "\(height)",
                color: .green
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20).fill(
                Color(.clear)
            ).shadow(radius: 5)
        )
    }
}

