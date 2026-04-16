//
//  EfficacyView.swift
//  Pokedex
//
//  Created by Freak on 06.04.2026.
//

import SwiftUI

struct EfficacyView: View {
    let title: String
    let efficacies: [TypeStrength]
    private let spacing: Int = 10

    var body: some View {
        VStack(alignment: .leading, spacing: CGFloat(spacing)) {
            Text(title)
                .font(.title2)
                .bold()
            cardScrollView

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    private var cardScrollView: some View {
        HStack {
          if !efficacies.isEmpty {
            ScrollView(.horizontal) {
                HStack(spacing: 24) {
                    ForEach(efficacies) { efficacy in
                        EfficacyCardView(
                            efficacy: efficacy,
                            iconURL: getIconUrl(for: efficacy.id)
                        )
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize, axes: [.horizontal])
           } else {
                Spacer()
                Text("To be discovered...")
                Spacer()
            }

        }
    }

    func getIconUrl(for id: Int) -> URL? {
        URL(
            string:
                PokedexStrings.getIconURLString(for: id)
        )
    }
}

#Preview {
    EfficacyView(
        title: "Strong against",
        efficacies: [
            TypeStrength(name: "Normal", id: 1),
            TypeStrength(name: "Fighting", id: 2),
            TypeStrength(name: "Flying", id: 3),
            TypeStrength(name: "Poison", id: 4),
            TypeStrength(name: "Ground", id: 5),
            TypeStrength(name: "Rock", id: 6),
            TypeStrength(name: "Bug", id: 7),
            TypeStrength(name: "Ghost", id: 8),
            TypeStrength(name: "Steel", id: 9),
        ]
    )
}
