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
                        HStack {
                            ForEach(efficacies, id: \.1) { efficacy in
                                EfficacyCardView(efficacy: efficacy, getIconUrl: getIconUrl)
                            }
                        }
                    }.scrollIndicators(.hidden)

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
    let efficacy:(String,Int)
    let getIconUrl: (Int) -> URL?
    var body: some View {
        HStack {
            AsyncImage(url: getIconUrl(efficacy.1))
            Text(efficacy.0)
        }
    }
}

#Preview{
    EfficacyView(
        title: "Strong against",
        efficacies: [("Normal",1),("Fighting",2),("Flying",3)]
    )
}
