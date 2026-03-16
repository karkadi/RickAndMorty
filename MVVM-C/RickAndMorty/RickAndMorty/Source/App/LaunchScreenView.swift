//
//  LaunchScreenView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Launch Screen
import SwiftUI
import MetalKitUI

struct LaunchScreenView: View {
    @State private var isActive = false
    @State private var opacity = 1.0
    
    var body: some View {
        if isActive {
            ContentView()
        } else {
            landingScreen
        }
    }

    // Landing Screen
    private var landingScreen: some View {
        ZStack {
            MetalView(fragmentFunction: "fragment_main_fire")
            
            VStack {
                Spacer()
                Button(action: {
                    Task {
                        // Animate the transition
                        withAnimation(.easeIn(duration: 1.2)) {
                            self.isActive = true
                            self.opacity = 0.0
                        }
                    }
                }, label: {
                    Image("Rick_et_Morty_Logo_FR")
                        .resizable()
                        .scaledToFit()
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(lineWidth: 2))
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow, radius: 2)
                        .shadow(color: .yellow, radius: 4)
                        .shadow(color: .yellow, radius: 10)
                })
                
                Spacer()
            }
            .padding([.leading, .trailing], 20)
        }
        .background(Color.black)
        .opacity(opacity)
        .transition(.opacity)
        .ignoresSafeArea(.all)

    }
}

#Preview {
    LaunchScreenView()
        .preferredColorScheme(.dark)
}
