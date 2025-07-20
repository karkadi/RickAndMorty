//
//  LaunchScreenView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import SwiftUI

struct LaunchScreenView: View {
    let store: StoreOf<LaunchScreenReducer>

    init() {
        self.store = Store(initialState: LaunchScreenReducer.State()) { LaunchScreenReducer() }
    }

    var body: some View {
        switch store.state.entity {
        case .splashScreen:
            Color.background
                .ignoresSafeArea(edges: .all)
                .onAppear {
                    store.send(.onAppear, animation: .easeInOut(duration: 2.0))
                }

        case .landingScreen:
            landingScreen

        case .appScreen:
            RootView(store: Store(initialState: RootReducer.State()) { RootReducer() })
        }
    }

    // Landing Screen
    private var landingScreen: some View {
        ZStack {
            MetalView(fragmentFunction: "fragment_main_fire")

            VStack {
                Spacer()
                Button(action: {
                    store.send(.startButtonTapped, animation: .easeInOut(duration: 1.0))
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
        .background(Color.background)
        .transition(.opacity)
        .ignoresSafeArea(.all)
    }
}

#Preview {
    LaunchScreenView()
}
