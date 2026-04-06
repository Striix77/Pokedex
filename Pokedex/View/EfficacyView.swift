//
//  EfficacyView.swift
//  Pokedex
//
//  Created by Freak on 06.04.2026.
//

import SwiftUI

struct EfficacyView: View {
    let title: String
    let efficacies: [(String, Int)]
    private let spacing: Int = 10

    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat(spacing)) {
            Text(title)
                .font(.title2)

                .bold()
            VStack {
                HStack {
                    ScrollView(.horizontal) {
                        HStack(spacing: 24) {
                            ForEach(efficacies, id: \.1) { efficacy in
                                EfficacyCardView(
                                    efficacy: efficacy,
                                    getIconUrl: getIconUrl
                                )
                            }
                        }
                    }
                    .scrollIndicators(.hidden)
                    .scrollBounceBehavior(.basedOnSize, axes: [.horizontal])

                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    func getIconUrl(for id: Int) -> URL? {
        URL(
            string:
                "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/types/generation-ix/scarlet-violet/small/\(id).png"
        )
    }
}

struct EfficacyCardView: View {
    @Environment(\.colorScheme) var colorScheme
    let efficacy: (String, Int)
    let getIconUrl: (Int) -> URL?
    var body: some View {
        VStack {
            AsyncImage(url: getIconUrl(efficacy.1))
            Text(efficacy.0)

        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            TypeColor(rawValue: efficacy.0.lowercased())?.color.opacity(colorScheme == .light ? 0.5 : 0.3)
                ?? .gray
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    EfficacyView(
        title: "Strong against",
        efficacies: [
            ("Normal", 1), ("Fighting", 2), ("Flying", 3), ("Poison", 4),
            ("Ground", 5), ("Rock", 6), ("Bug", 7), ("Ghost", 8),
            ("Steel", 9),
        ]
    )
}
