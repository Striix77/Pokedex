//
//  ContainerBackground.swift
//  Pokedex
//
//  Created by Freak on 09.06.2026.
//
import SwiftUI

struct ContainerBackgroundModifier: ViewModifier {
    let cornerRadius: CGFloat
    let fill: Color
    let stroke: Color
    let lineWidth: CGFloat

    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(fill)
                    .overlay(
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(stroke, lineWidth: lineWidth)
                    )
            )
    }
}

extension View {
    func containerBackground(
        cornerRadius: CGFloat,
        fill: Color = Color.containerBackground,
        stroke: Color = Color.containerBorder,
        lineWidth: CGFloat = 1
    ) -> some View {
        modifier(ContainerBackgroundModifier(
            cornerRadius: cornerRadius,
            fill: fill,
            stroke: stroke,
            lineWidth: lineWidth
        ))
    }
}
