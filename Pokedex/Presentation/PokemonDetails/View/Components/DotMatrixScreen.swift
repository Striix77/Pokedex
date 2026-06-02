//
//  DotMatrixScreen.swift
//  Pokedex
//
//  Created by Freak on 02.06.2026.
//
import SwiftUI

struct DotMatrixScreen: View {
    let accentColor: Color

    private let dotSize: CGFloat = 3
    private let spacing: CGFloat = 7
    private let dotOpacity: CGFloat = 0.1

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
                    with: .color(.gray.opacity(dotOpacity))
                )
            }
        }
    }
}
