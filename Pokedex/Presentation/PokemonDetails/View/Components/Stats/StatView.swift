//
//  StatView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct StatView: View {
    let label: String
    let value: String

    var body: some View {
        VStack(spacing: 10) {
            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.containerBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22)
                .stroke(Color.containerBorder, lineWidth: 1)
        )
    }
}

#Preview {
    StatView(label: "Category", value: "Tiny Turtle")
}
