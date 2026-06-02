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

    init(
        efficacy: TypeStrength,
        hStackSpacing: CGFloat = 12,
        iconMaxWidth: CGFloat = 25,
        iconCornerRadius: CGFloat = 8,
        iconShadowRadius: CGFloat = 4,
        pillHorizontalPadding: CGFloat = 12,
        pillVerticalPadding: CGFloat = 12,
        pillCornerRadius: CGFloat = 16,
        backgroundOpacity: CGFloat = 0.7
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
    }

    var body: some View {
        HStack(spacing: hStackSpacing) {
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
            Text(efficacy.name)
                .font(.headline)
                .fontWeight(.bold)
        }
        .padding(.horizontal, pillHorizontalPadding)
        .padding(.vertical, pillVerticalPadding)
        .background(
            TypeColor(rawValue: efficacy.name.lowercased())?.color.opacity(backgroundOpacity)
        )
        .clipShape(RoundedRectangle(cornerRadius: pillCornerRadius))
    }
}

#Preview {
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
