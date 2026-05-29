//
//  PokemonHeroCard.swift
//  Pokedex
//
//  Created by Freak on 29.05.2026.
//
import SwiftUI

struct PokemonHeroCard: View {
    @State private var imageOffset: CGFloat = 0
    let pokemonListEntry: PokemonListEntry
    let typeColors: (Color?, Color?)

    private let maxImageOffset: CGFloat = 25

    private var backgroundColors: (Color, Color) {
        (typeColors.0 ?? Color.pokemonHeroCardBackground,
         typeColors.1 ?? Color.pokemonHeroCardBackground)
    }

    private var backgroundColor: Color {
        Color.pokemonHeroCardBackground
    }

    private var accentColor: Color {
        typeColors.0 ?? Color.clear
    }

    var body: some View {
        ZStack {
            background

            mainContent
                .padding()
        }
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(accentColor, lineWidth: 3)
        )
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                backgroundColor
            )
            .overlay(
                RadialGradient(stops: [
                    Gradient.Stop(color: backgroundColors.0, location: 0),
                    Gradient.Stop(color: backgroundColors.1, location: 1),
                ], center: .top, startRadius: 1, endRadius: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .opacity(0.2)
            )
    }

    private var mainContent: some View {
        VStack {
            header

            retroScreen

            PokemonInfoHeaderView(pokemonName: pokemonListEntry.name)
        }
    }

    private var header: some View {
        HStack {
            Text("#\(String(format: "%03d", pokemonListEntry.id))")

            Spacer()

            HStack {
                Image(systemName: "circle.fill")
                    .scaleEffect(0.5)

                Text(pokemonListEntry.formattedGeneration)
            }
        }
        .foregroundStyle(accentColor)
        .bold()
        .monospaced()
    }

    private var retroScreen: some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(
                retroScreenCornerLightBleed
            )
            .overlay(
                DotMatrixScreen(accentColor: accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            )
            .overlay(
                retroScreenBorder
            )
            .overlay(
                retroScreenPicture
                    .clipped()
            )
    }

    private var retroScreenCornerLightBleed: some ShapeStyle {
        RadialGradient(stops: [
            Gradient.Stop(color: backgroundColor, location: 0),
            Gradient.Stop(color: accentColor, location: 1),
        ], center: .center, startRadius: 150, endRadius: 325)
            .opacity(0.3)
    }

    private var retroScreenBorder: some View {
        RoundedRectangle(cornerRadius: 20)
            .stroke(
                RadialGradient(
                    colors: [.white, .white.opacity(0.2)],
                    center: .center,
                    startRadius: 1,
                    endRadius: 180
                ),
                lineWidth: 2
            )
    }

    private var retroScreenPicture: some View {
        GeometryReader { geo in
            let width = geo.size.width / 2
            ZStack {
                RadialGradient(stops: [
                    Gradient.Stop(color: accentColor, location: 0),
                    Gradient.Stop(color: .clear, location: 1),
                ], center: .center, startRadius: 5, endRadius: 75)
                    .scaleEffect(2)
                    .opacity(0.3)
                    .offset(x: 0, y: imageOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                            imageOffset = -maxImageOffset
                        }
                    }
                PokemonImageView(spriteURL: pokemonListEntry.spriteURL)
                    .frame(maxWidth: width)
                    .offset(x: 0, y: imageOffset)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

struct DotMatrixScreen: View {
    let accentColor: Color

    private let dotSize: CGFloat = 3
    private let spacing: CGFloat = 7

    var body: some View {
        Canvas { context, size in
            drawDots(context: context, size: size)
        }
    }

    private func drawDots(context: GraphicsContext, size: CGSize) {
        let columns = Int(size.width / spacing)
        let rows = Int(size.height / spacing)

        for row in 0..<rows {
            for col in 0..<columns {
                let x = CGFloat(col) * spacing + spacing / 2
                let y = CGFloat(row) * spacing + spacing / 2

                let rect = CGRect(
                    x: x - dotSize / 2,
                    y: y - dotSize / 2,
                    width: dotSize,
                    height: dotSize
                )
                context.fill(
                    Path(ellipseIn: rect),
                    with: .color(.gray.opacity(0.1))
                )
            }
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [TypeColor.water.color, Color.pokemonHeroCardBackground], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            .opacity(0.5)

        PokemonHeroCard(pokemonListEntry: .mock, typeColors: (TypeColor.water.color, nil))
            .padding()
            .padding(.bottom, 350)
    }
    .environment(SoundManager())
}
