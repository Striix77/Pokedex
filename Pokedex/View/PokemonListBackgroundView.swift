//
//  PokemonListBackgroundView.swift
//  Pokedex
//
//  Created by Freak on 15.04.2026.
//
import SwiftUI

struct PokemonListBackgroundView: View {
    var stops: [Gradient.Stop]
    
    var body: some View {
        ZStack{
            LinearGradient(
                stops: stops,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack{
                HStack {
                    Spacer()
                    Image("PokeballIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width:350)
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
            color: Color.listViewBackground1,
            location: 0.0
        ),
        Gradient.Stop(color: Color.listViewBackground2, location: 1.0)
    ])
}
