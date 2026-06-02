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
    private let cardCornerRadius: CGFloat = 20
    private let cardBorderLineWidth: CGFloat = 3
    private let backgroundGradientOpacity: CGFloat = 0.2
    private let backgroundGradientStartRadius: CGFloat = 1
    private let backgroundGradientEndRadius: CGFloat = 400
    private let retroScreenHeight: CGFloat = 300
    private let retroScreenCornerLightBleedStartRadius: CGFloat = 150
    private let retroScreenCornerLightBleedEndRadius: CGFloat = 325
    private let retroScreenCornerLightBleedOpacity: CGFloat = 0.3
    private let retroScreenBorderStartRadius: CGFloat = 1
    private let retroScreenBorderEndRadius: CGFloat = 180
    private let retroScreenBorderLineWidth: CGFloat = 2
    private let retroScreenPictureGlowStartRadius: CGFloat = 5
    private let retroScreenPictureGlowEndRadius: CGFloat = 75
    private let retroScreenPictureGlowScale: CGFloat = 2
    private let retroScreenPictureGlowOpacity: CGFloat = 0.3
    private let floatAnimationDuration: CGFloat = 3
    private let headerIconScale: CGFloat = 0.5
    private let imageWidthFraction: CGFloat = 2

    private var backgroundColors: (Color, Color) {
        (typeColors.0 ?? Color.pokemonHeroCardBackground,
         typeColors.1 ?? Color.pokemonHeroCardBackground)
    }

    private var backgroundColor: Color {
        Color.pokemonHeroCardBackground
    }

    private var screenBackgroundColor: Color {
        Color.pokemonHeroCardScreenBackground
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
            RoundedRectangle(cornerRadius: cardCornerRadius)
                .stroke(accentColor, lineWidth: cardBorderLineWidth)
        )
    }

    private var background: some View {
        RoundedRectangle(cornerRadius: cardCornerRadius)
            .fill(
                backgroundColor
            )
            .overlay(
                RadialGradient(stops: [
                    Gradient.Stop(color: backgroundColors.0, location: 0),
                    Gradient.Stop(color: backgroundColors.1, location: 1),
                ], center: .top, startRadius: backgroundGradientStartRadius, endRadius: backgroundGradientEndRadius)
                    .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
                    .opacity(backgroundGradientOpacity)
            )
    }

    private var mainContent: some View {
        VStack {
            header

            retroScreen

            PokemonInfoHeaderView(pokemonName: pokemonListEntry.name, pokemonTypes: pokemonListEntry.pokemontypes, accentColor: accentColor)
        }
    }

    private var header: some View {
        HStack {
            Text("#\(String(format: "%03d", pokemonListEntry.id))")

            Spacer()

            HStack {
                Image(systemName: "circle.fill")
                    .scaleEffect(headerIconScale)

                Text(pokemonListEntry.formattedGeneration)
            }
        }
        .foregroundStyle(accentColor)
        .bold()
        .monospaced()
    }

    private var retroScreen: some View {
        RoundedRectangle(cornerRadius: cardCornerRadius)
            .fill(
                screenBackgroundColor
            )
            .overlay(
                retroScreenCornerLightBleed
            )
            .overlay(
                DotMatrixScreen(accentColor: accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
            )
            .overlay(
                retroScreenBorder
            )
            .overlay(
                retroScreenPicture
                    .clipped()
            )
            .frame(height: retroScreenHeight)
    }

    private var retroScreenCornerLightBleed: some View {
        RadialGradient(stops: [
            Gradient.Stop(color: screenBackgroundColor, location: 0),
            Gradient.Stop(color: accentColor, location: 1),
        ], center: .center, startRadius: retroScreenCornerLightBleedStartRadius, endRadius: retroScreenCornerLightBleedEndRadius)
            .opacity(retroScreenCornerLightBleedOpacity)
            .clipShape(RoundedRectangle(cornerRadius: cardCornerRadius))
    }

    private var retroScreenBorder: some View {
        RoundedRectangle(cornerRadius: cardCornerRadius)
            .stroke(
                RadialGradient(
                    colors: [.white, .white.opacity(0.2)],
                    center: .center,
                    startRadius: retroScreenBorderStartRadius,
                    endRadius: retroScreenBorderEndRadius
                ),
                lineWidth: retroScreenBorderLineWidth
            )
    }

    private var retroScreenPicture: some View {
        GeometryReader { geo in
            let width = geo.size.width / imageWidthFraction
            ZStack {
                RadialGradient(stops: [
                    Gradient.Stop(color: accentColor, location: 0),
                    Gradient.Stop(color: .clear, location: 1),
                ], center: .center, startRadius: retroScreenPictureGlowStartRadius, endRadius: retroScreenPictureGlowEndRadius)
                    .scaleEffect(retroScreenPictureGlowScale)
                    .opacity(retroScreenPictureGlowOpacity)
                    .offset(x: 0, y: imageOffset)
                    .onAppear {
                        withAnimation(.easeInOut(duration: floatAnimationDuration).repeatForever(autoreverses: true)) {
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

#Preview {
    ZStack {
        LinearGradient(colors: [TypeColor.grass.color, Color.pokemonHeroCardBackground], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
            .opacity(0.5)

        PokemonHeroCard(
            pokemonListEntry: .mock,
            typeColors: (TypeColor.grass.color, nil)
        )
        .padding()
        .padding(.bottom, 350)
    }
    .environment(SoundManager())
}
