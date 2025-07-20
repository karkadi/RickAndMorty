//
//  AboutView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 08/04/2025.
//

import ComposableArchitecture
import SwiftUI

struct AboutView: View {
    let store: StoreOf<AboutReducer>

    var body: some View {
        ZStack {
            MetalView(fragmentFunction: "fragment_main_matrix")

            VStack(spacing: 16) {
                Spacer()

                VStack(spacing: 28) {
                    Text(store.aboutInfo.appName)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)

                    Text(store.aboutInfo.creator)
                        .font(.headline)
                        .foregroundColor(.white)

                    Text(store.aboutInfo.creationDate)
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .background(Color.background)
        .transition(.opacity)
        .ignoresSafeArea(.all)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    AboutView(store: Store( initialState: AboutReducer.State()) { AboutReducer() })
}
