//
//  PokemonStatsView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct PokemonStatsView: View {
    let weight: Int
    let height: Int
    let category: String?

    private let weightLabel = "Weight"
    private let heightLabel = "Height"
    private let categoryLabel = "Category"

    var body: some View {
        HStack(spacing: 24) {
            StatView(
                label: weightLabel,
                value: "\(weight)"
            )

            StatView(
                label: heightLabel,
                value: "\(height)"
            )

            if let categoryValue = category {
                StatView(
                    label: categoryLabel,
                    value: categoryValue
                )
            }
        }
    }
}
