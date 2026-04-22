//
//  PokemonListBackgroundView.swift
//  Pokedex
//
//  Created by Freak on 15.04.2026.
//
import SwiftUI

struct PokemonListBackgroundView: View {
    @State private var animateGradient = false
    var stops: [Gradient.Stop]

    var body: some View {
        ZStack {
            LinearGradient(
                stops: stops,
                startPoint: animateGradient ? .topLeading : UnitPoint(x: UnitPoint.topLeading.x + 0.2, y: UnitPoint.topLeading.y + 0.2),
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 30).repeatForever(autoreverses: true)
                ) {
                    animateGradient.toggle()
                }
            }
            ZStack {
                Image("PokeballIcon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 350)
                    .opacity(0.3)
                    .rotationEffect(Angle(degrees: -30))

            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topTrailing
            )
            .offset(x: 50)
        }
    }
}

#Preview {
    @Previewable @State var viewModel = PokemonViewModel()
    PokemonListView(viewModel: viewModel)
}

#Preview {
    PokemonListBackgroundView(stops: [
        Gradient.Stop(
            color: Color.listViewBackground1,
            location: 0.0
        ),
        Gradient.Stop(
            color: Color.listViewBackground2,
            location: 0.4
        ),
        Gradient.Stop(
            color: Color.listViewBackground2,
            location: 1.0
        ),
    ])
}
