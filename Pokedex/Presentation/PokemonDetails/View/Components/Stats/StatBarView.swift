//
//  StatBarView.swift
//  Pokedex
//
//  Created by Freak on 02.04.2026.
//

import SwiftUI

struct StatBarView: View {
    let label: String
    let value: Int
    let maxValue: Double = 255
    let color: Color

    var body: some View {
        HStack {
            Text(label.uppercased())
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 50, alignment: .leading)

            Text("\(value)")
                .font(.caption)
                .fontWeight(.bold)
                .frame(width: 35)

            // The actual visual bar
            ProgressView(value: Double(value), total: maxValue)
                .tint(color)
        }
    }
}
