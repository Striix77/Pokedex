//
//  PokemonDetailsTabBar.swift
//  Pokedex
//
//  Created by Freak on 02.06.2026.
//
import SwiftUI

struct PokemonDetailsTabBarView: View {
    @Binding var selectedTab: PokemonDetailTab

    private let contentSpacing: CGFloat = 4
    private let buttonHorizontalPadding: CGFloat = 14
    private let buttonVerticalPadding: CGFloat = 12
    private let containerHorizontalPadding: CGFloat = 6
    private let containerVerticalPadding: CGFloat = 10
    private let containerCornerRadius: CGFloat = 20
    private let containerBackgroundOpacity: CGFloat = 0.2
    private let containerBorderOpacity: CGFloat = 0.3
    private let containerBorderLineWidth: CGFloat = 1
    private let animationDuration: CGFloat = 0.25
    private let buttonCornerRadius: CGFloat = 16
    private let buttonBackgroundOpacity: CGFloat = 0.8
    private let buttonBackgroundOffset: CGFloat = -1

    var body: some View {
        HStack(spacing: contentSpacing) {
            ForEach(PokemonDetailTab.allCases, id: \.self) { tab in
                VStack {
                    Text(tab.title)
                        .foregroundStyle(selectedTab == tab ? .primary : .secondary)
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
                .padding(.horizontal, buttonHorizontalPadding)
                .padding(.vertical, buttonVerticalPadding)
                .background(
                    tabButtonBackground
                        .opacity(selectedTab == tab ? 1 : 0)
                )
                .onTapGesture {
                    withAnimation(.easeInOut(duration: animationDuration)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, containerHorizontalPadding)
        .padding(.vertical, containerVerticalPadding)
        .background(
            RoundedRectangle(cornerRadius: containerCornerRadius)
                .fill(Color.gray.opacity(containerBackgroundOpacity))
        )
        .overlay(
            RoundedRectangle(cornerRadius: containerCornerRadius)
                .stroke(Color.gray.opacity(containerBorderOpacity), lineWidth: containerBorderLineWidth)
        )
    }

    private var tabButtonBackground: some View {
        return ZStack {
            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(Color.white)
                .overlay(
                    Color.tabBarButtonBackground
                        .clipShape(RoundedRectangle(cornerRadius: buttonCornerRadius))
                        .opacity(buttonBackgroundOpacity)
                )
                .offset(x: 0, y: buttonBackgroundOffset)

            RoundedRectangle(cornerRadius: buttonCornerRadius)
                .fill(Color.tabBarButtonBackground)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    @Previewable @State var selectedTab = PokemonDetailTab.about
    PokemonDetailsTabBarView(selectedTab: $selectedTab)
}
