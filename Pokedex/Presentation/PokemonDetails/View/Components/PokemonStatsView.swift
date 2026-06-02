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

    private let typeLabel = "Type"
    private let weightLabel = "Weight"
    private let heightLabel = "Height"

    var body: some View {
        HStack(spacing: 40) {
            StatView(
                label: typeLabel,
                value: typeString,
                color: .orange
            )
            StatView(
                label: weightLabel,
                value: "\(weight)",
                color: .blue
            )
            StatView(
                label: heightLabel,
                value: "\(height)",
                color: .green
            )
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20).fill(
                .ultraThinMaterial
            ).shadow(radius: 5)
        )
    }
}

