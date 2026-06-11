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
        .containerBackground(cornerRadius: 22)
    }
}

#Preview {
    StatView(label: "Category", value: "Tiny Turtle")
}
