//
//  LaunchScreenView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import SwiftUI

struct LaunchScreenView: View {
    let store: StoreOf<LaunchScreenViewModel>

    init() {
        self.store = Store(initialState: LaunchScreenViewModel.State()) { LaunchScreenViewModel() }
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
