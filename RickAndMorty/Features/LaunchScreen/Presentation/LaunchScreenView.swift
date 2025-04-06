//
//  LaunchScreenView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import SwiftUI

struct LaunchScreenView: View {
    let store: StoreOf<LaunchScreenFeature>

    init() {
        self.store = Store(initialState: LaunchScreenFeature.State()) { LaunchScreenFeature() }
    }

    var body: some View {
        switch store.state.entity {
        case .landingScreen:
            landingScreen

        case .appScreen:
            CharactersGridView()

        case .splashScreen:
            Color.background
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    store.send(.onAppear, animation: .easeInOut(duration: 2.0))
                }
        }
    }

    // Landing Screen
    private var landingScreen: some View {
        ZStack {
            MetalView()
                .opacity(store.state.isLandingContentVisible ? 1 : 0)
            VStack {
                Spacer()
                Button(action: {
                    store.send(.startButtonTapped, animation: .easeInOut(duration: 1.0))
                }, label: {
                    Text("Start")
                        .font(.title)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(lineWidth: 2))
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow, radius: 5)
                        .shadow(color: .yellow, radius: 20)
                        .shadow(color: .yellow, radius: 50)
                        .scaleEffect(store.state.isLandingContentVisible ? 1 : 0.5)
                        .opacity(store.state.isLandingContentVisible ? 1 : 0)
                })
                Spacer()
            }
            .padding([.leading, .trailing], 50)
        }
        .background(Color.background)
        .transition(.opacity)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LaunchScreenView()
}
