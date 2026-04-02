//
//  StatVStack.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct StatView: View {
    let label: String
    let value: String
    let color: Color

    var body: some View {
        VStack {
            Text(label)
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
            Text(value)
                .font(.headline)
                .foregroundColor(color)
        }
    }
}

