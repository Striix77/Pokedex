//
//  PokeballProgressView.swift
//  Pokedex
//
//  Created by Freak on 07.05.2026.
//

import SwiftUI

struct PokeballProgressView: View {
    @State private var rotation: CGFloat = 0
    private let rotations = 1
    private let duration: Double = 3

    private var rotationAmount: CGFloat {
        CGFloat(360 * rotations)
    }

    var body: some View {
        ZStack {
            Group {
                Image("pokeprogress_top")
                    .resizable()
                    .scaledToFit()
                Image("pokeprogress_bottom")
                    .resizable()
                    .scaledToFit()
            }
            .rotationEffect(Angle(degrees: rotation))
            .onAppear {
                withAnimation(
                    .linear(duration: duration).repeatForever(
                        autoreverses: false
                    )
                ) {
                    rotation = rotationAmount
                }
            }
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    PokeballProgressView()
        .padding(64)
}
