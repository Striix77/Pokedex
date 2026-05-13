//
//  PokeballProgressView.swift
//  Pokedex
//
//  Created by Freak on 07.05.2026.
//

import SwiftUI

struct PokeballProgressView: View {
    @Binding var isLoading: Bool

    @State private var isAnimating: Bool = false
    @State private var yOffset: CGFloat = 0
    @State private var opacity: CGFloat = 1
    @State private var rotation: CGFloat = 0

    private let endRotationAmount: CGFloat = 720
    private let yOffsetAmount: CGFloat = 300
    private let rotations = 1
    private let duration: Double = 3
    private let endRotationDuration: Double = 0.5
    private let completionAnimationDuration: Double = 0.3

    private var rotationAmount: CGFloat {
        CGFloat(360 * rotations)
    }

    var body: some View {
        pokeball
        .opacity(opacity)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            withAnimation(
                .linear(duration: duration).repeatForever(
                    autoreverses: false
                )
            ) {
                rotation = rotationAmount
            }
        }
        .onChange(of: isLoading) { _, newValue in
            if !newValue {
                withAnimation(.easeOut(duration: endRotationDuration)) {
                    rotation = endRotationAmount
                } completion: {
                    withAnimation(.easeIn(duration: completionAnimationDuration)) {
                        yOffset = yOffsetAmount
                        opacity = 0
                        onFinished?()
                    }
                }
            }
        }
    }

    private var pokeball: some View {
        ZStack {
            Image(.pokeProgressTop)
                .resizable()
                .scaledToFit()
                .offset(x: 0, y: -yOffset)
            Image(.pokeProgressBottom)
                .resizable()
                .scaledToFit()
                .offset(x: 0, y: yOffset)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var isLoading = true
    PokeballProgressView(isLoading: $isLoading)
        .padding(64)
    Button("Animate") {
        isLoading.toggle()
    }
    .buttonStyle(.glassProminent)
}
