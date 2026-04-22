//
//  EfficacyCardView.swift
//  Pokedex
//
//  Created by Freak on 06.04.2026.
//


import SwiftUI

struct EfficacyCardView: View {
    @Environment(\.colorScheme) var colorScheme
    let efficacy: TypeStrength
    let iconURL: URL?

    var body: some View {
        VStack {
            //TODO: Replace with Kingfisher
            AsyncImage(url: iconURL) { image in
                image
                    .image?.resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 56, height: 56)
            .shadow(radius: 4)
            Text(efficacy.name)

        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            TypeColor(rawValue:efficacy.name.lowercased())?.color.opacity(0.7)
        )
        .clipShape(RoundedRectangle(cornerRadius: 8))
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
