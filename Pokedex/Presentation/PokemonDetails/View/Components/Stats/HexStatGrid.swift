//
//  HexStatGrid.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import SwiftUI

struct HexStatGrid: View {
    let stats: PokemonStats
    let accentColor: Color

    private let ringCount = 5
    private let radiusFraction: CGFloat = 1
    private let gridLineOpacity: CGFloat = 0.25
    private let gridLineWidth: CGFloat = 1
    private let labelOffset: CGFloat = 24
    private let maxStatValue: CGFloat = 255
    private let pointRadius: CGFloat = 5
    private let polygonFillOpacity: CGFloat = 0.3
    private let polygonStrokeWidth: CGFloat = 2.5
    private let shadowRadius: CGFloat = 10
    private let maxShadowExposure: CGFloat = 4

    @State private var polygonScaleEffect: CGFloat = 0
    @State private var polygonShadowExposure: CGFloat = 2

    var body: some View {
        Canvas { context, size in
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let radius = min(size.width, size.height) / 2 * radiusFraction

            drawHexagon(context: context, center: center, radius: radius)
        }
        .overlay(
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) / 2 * radiusFraction
                drawStatPolygon(context: context, center: center, radius: radius, color: accentColor, hasBorder: false)
            }
            .scaleEffect(polygonScaleEffect)
        )
        .overlay(
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) / 2 * radiusFraction
                drawStatPolygon(context: context, center: center, radius: radius, color: accentColor, isFilled: false)
            }
            .scaleEffect(polygonScaleEffect)
            .shadow(color: accentColor.exposureAdjust(polygonShadowExposure), radius: shadowRadius)
        )
        .overlay(
            Canvas { context, size in
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let radius = min(size.width, size.height) / 2 * radiusFraction
                drawStatPoints(context: context, center: center, radius: radius)
            }
            .scaleEffect(polygonScaleEffect)
        )
        .overlay(
            statOverlay
        )
        .onAppear {
            withAnimation(.easeInOut(duration: 0.75)) {
                polygonScaleEffect = 1
            }
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                polygonShadowExposure = maxShadowExposure
            }
        }
    }

    private var statOverlay: some View {
        GeometryReader { geo in
            let center = CGPoint(x: geo.size.width / 2, y: geo.size.height / 2)
            let radius = min(geo.size.width, geo.size.height) / 2 * radiusFraction

            ForEach(Array(stats.statsWithLabels.enumerated()), id: \.offset) { i, stat in
                let angle = -CGFloat.pi / 2 + CGFloat(i) * (2 * CGFloat.pi / 6)
                let x = center.x + (radius + labelOffset) * cos(angle)
                let y = center.y + (radius + labelOffset) * sin(angle)

                VStack(spacing: 2) {
                    Text(stat.label)
                        .foregroundStyle(.secondary)
                        .font(.default)
                        .bold()
                    Text("\(stat.value)")
                        .font(.default)
                        .bold()
                }
                .position(x: x, y: y)
            }
        }
    }

    private func drawHexagon(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        for ring in 1 ... ringCount {
            let scale = CGFloat(ring) / CGFloat(ringCount)
            context.stroke(
                hexPath(center: center, radius: radius * scale),
                with: .color(.gray.opacity(gridLineOpacity)),
                lineWidth: gridLineWidth
            )
        }
        context.stroke(centerLines(center: center, radius: radius), with: .color(.gray.opacity(gridLineOpacity)), lineWidth: gridLineWidth)
    }

    private func statPolygonPath(center: CGPoint, radius: CGFloat) -> Path {
        var path = Path()
        for (i, stat) in stats.statsWithLabels.enumerated() {
            let angle = -CGFloat.pi / 2 + CGFloat(i) * (2 * CGFloat.pi / 6)
            let scale = CGFloat(stat.value) / maxStatValue
            let point = CGPoint(
                x: center.x + radius * scale * cos(angle),
                y: center.y + radius * scale * sin(angle)
            )
            if i == 0 { path.move(to: point) } else { path.addLine(to: point) }
        }
        path.closeSubpath()
        return path
    }

    private func drawStatPolygon(
        context: GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        color: Color,
        isFilled: Bool = true,
        hasBorder: Bool = true
    ) {
        let path = statPolygonPath(center: center, radius: radius)
        if isFilled {
            context.fill(path, with: .color(color.opacity(polygonFillOpacity)))
        }
        if hasBorder {
            context.stroke(path, with: .color(color), lineWidth: polygonStrokeWidth)
        }
    }

    private func drawStatPoints(context: GraphicsContext, center: CGPoint, radius: CGFloat) {
        for (i, stat) in stats.statsWithLabels.enumerated() {
            let angle = -CGFloat.pi / 2 + CGFloat(i) * (2 * CGFloat.pi / 6)
            let scale = CGFloat(stat.value) / maxStatValue
            let point = CGPoint(
                x: center.x + radius * scale * cos(angle),
                y: center.y + radius * scale * sin(angle)
            )
            let dotRect = CGRect(
                x: point.x - pointRadius,
                y: point.y - pointRadius,
                width: pointRadius * 2,
                height: pointRadius * 2
            )
            context.fill(Path(ellipseIn: dotRect), with: .color(.primary))
        }
    }

    private func centerLines(center: CGPoint, radius: CGFloat) -> Path {
        var path = Path()
        for i in 0..<6 {
            let angle = -CGFloat.pi / 2 + CGFloat(i) * (2 * CGFloat.pi / 6)
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )

            path.move(to: center)
            path.addLine(to: point)
        }
        path.closeSubpath()
        return path
    }

    private func hexPath(center: CGPoint, radius: CGFloat) -> Path {
        var path = Path()
        for i in 0..<6 {
            let angle = -CGFloat.pi / 2 + CGFloat(i) * (2 * CGFloat.pi / 6)
            let point = CGPoint(
                x: center.x + radius * cos(angle),
                y: center.y + radius * sin(angle)
            )
            if i == 0 {
                path.move(to: point)
            } else {
                path.addLine(to: point)
            }
        }
        path.closeSubpath()
        return path
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    HexStatGrid(
        stats: PokemonStats(hp: 230, atk: 240, def: 200, spa: 150, spd: 240, spe: 220),
        accentColor: TypeColor.water.color
    )
    .frame(width: 280, height: 280)
    .padding(40)
}
