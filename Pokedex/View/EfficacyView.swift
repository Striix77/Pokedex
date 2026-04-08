//
//  EfficacyView.swift
//  Pokedex
//
//  Created by Freak on 03.04.2026.
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
            if !efficacies.isEmpty {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(efficacies) { efficacy in
                            HStack {
                                AsyncImage(url: getIconUrl(for: efficacy.id))
                                Text(efficacy.name)
                            }
                        }
                    }
                }.scrollIndicators(.hidden)
            } else {
                Spacer()
                Text("To be discovered...")
                Spacer()
            }

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
    }

    func getIconUrl(for id: Int) -> URL? {
        URL(
            string: PokedexStrings.getIconURLString(for: id)
        )
    }
}
