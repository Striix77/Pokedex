//
//  GlowingRing.swift
//  Pokedex
//
//  Created by Freak on 29.04.2026.
//
import SwiftUI

struct GlowingRing: View {
    let colors: (Color?, Color?)
    @State private var rotation: Double = 0
    @State private var scale: Double = 0
    @State private var opacity: Double = 1

    var body: some View {
        let color1 = colors.0 ?? .white
        let color2 = colors.1 ?? color1

        Circle()
            .stroke(
                AngularGradient(
                    colors: [color1, color2, color1],
                    center: .center
                ),
                lineWidth: 16
            )
            .blur(radius: 28)
            .rotationEffect(.degrees(rotation))
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 5).repeatForever(autoreverses: false)) {
                    rotation = 360
                    scale = 3
                    opacity = 0
                }
            }
    }
}
