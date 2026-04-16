//
//  PokemonListBackgroundView.swift
//  Pokedex
//
//  Created by Freak on 15.04.2026.
//
import SwiftUI

struct PokemonListBackgroundView: View {
    var body: some View {
        LinearGradient(
            stops: [
                Gradient.Stop(
                    color: Color(red: 0.898, green: 0.4196, blue: 0.4275),
                    location: 0.0
                ),
                Gradient.Stop(color: Color(red: 0.4471, green: 0.1529, blue: 0.2784), location: 1.0)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
        ZStack{
            VStack{
                HStack {
                    Spacer()
                    Image("PokeballIcon")
                        .resizable()
                        .frame(width:280, height:180)
                        .opacity(0.3)
                        .rotationEffect(Angle(degrees: -30))
                        
                }
                .padding(.top, 75)
                Spacer()
            }
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
            color: Color(red: 0.898, green: 0.4196, blue: 0.4275),
            location: 0.0
        ),
        Gradient.Stop(color: Color(red: 0.4471, green: 0.1529, blue: 0.2784), location: 1.0)
    ])
}
