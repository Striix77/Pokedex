//
//  EfficacyCardView.swift
//  Pokedex
//
//  Created by Freak on 06.04.2026.
//
import Kingfisher
import SwiftUI

struct EfficacyPill: View {
    @Environment(\.colorScheme) var colorScheme
    let efficacy: TypeStrength

    let hStackSpacing: CGFloat
    let iconMaxWidth: CGFloat
    let iconCornerRadius: CGFloat
    let iconShadowRadius: CGFloat
    let pillHorizontalPadding: CGFloat
    let pillVerticalPadding: CGFloat
    let pillCornerRadius: CGFloat
    let backgroundOpacity: CGFloat
    let shadowRadius: Double

    init(
        efficacy: TypeStrength,
        hStackSpacing: CGFloat = 12,
        iconMaxWidth: CGFloat = 25,
        iconCornerRadius: CGFloat = 8,
        iconShadowRadius: CGFloat = 4,
        pillHorizontalPadding: CGFloat = 12,
        pillVerticalPadding: CGFloat = 12,
        pillCornerRadius: CGFloat = 16,
        backgroundOpacity: CGFloat = 0.7,
        shadowRadius: Double = 4
    ) {
        self.efficacy = efficacy
        self.hStackSpacing = hStackSpacing
        self.iconMaxWidth = iconMaxWidth
        self.iconCornerRadius = iconCornerRadius
        self.iconShadowRadius = iconShadowRadius
        self.pillHorizontalPadding = pillHorizontalPadding
        self.pillVerticalPadding = pillVerticalPadding
        self.pillCornerRadius = pillCornerRadius
        self.backgroundOpacity = backgroundOpacity
        self.shadowRadius = shadowRadius
    }

    private var backgroundColor: Color? {
        TypeColor(rawValue: efficacy.name.lowercased())?.color.opacity(backgroundOpacity)
    }

    var body: some View {
        ZStack {
            mainPill
        }
    }

    private var mainPill: some View {
        HStack(spacing: hStackSpacing) {
            pillImage

            pillText
        }
        .padding(.horizontal, pillHorizontalPadding)
        .padding(.vertical, pillVerticalPadding)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: pillCornerRadius))
        .shadow(color: backgroundColor ?? Color.black, radius: shadowRadius)
    }

    private var pillImage: some View {
        KFImage(EfficacyCardHelper.getIconUrl(for: efficacy.id))
            .placeholder {
                Image(systemName: "questionmark.circle.fill")
                    .imageScale(.large)
            }
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: iconMaxWidth)
            .aspectRatio(1, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: iconCornerRadius))
            .shadow(radius: iconShadowRadius)
    }

    private var pillText: some View {
        Text(efficacy.name)
            .font(.headline)
            .fontWeight(.bold)
    }
}

#Preview("Efficacy View") {
    EfficacyView(
        title: "Strong against",
        efficacies: [
            TypeStrength(name: "Poison", id: 4),
            TypeStrength(name: "Ground", id: 5),
            TypeStrength(name: "Rock", id: 6),
            TypeStrength(name: "Bug", id: 7),
            TypeStrength(name: "Ghost", id: 8),
            TypeStrength(name: "Steel", id: 9),
            TypeStrength(name: "Stellar", id: 19),
            TypeStrength(name: "Unknown", id: 10001),
            TypeStrength(name: "Shadow", id: 10002),
        ]
    )
}

#Preview("Single Pill", traits: .sizeThatFitsLayout) {
    EfficacyPill(efficacy: .init(name: "Water", id: 11))
        .padding()
}
