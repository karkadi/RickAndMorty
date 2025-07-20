//
//  RootView.swift
//  InstagramLikeApp
//
//  Created by Arkadiy KAZAZYAN on 19/07/2025.
//
import ComposableArchitecture
import SwiftUI

// MARK: - Views
struct RootView: View {
    @Bindable var store: StoreOf<RootReducer>

    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            CharactersGridView(store: store.scope(state: \.main, action: \.main))
        } destination: { store in
            switch store.state {
            case .aboutView:
                IfLetStore(store.scope(state: \.aboutView, action: \.aboutView)) {
                    AboutView(store: $0)
                }

            case .storyDetails:
                IfLetStore(store.scope(state: \.storyDetails, action: \.storyDetails) ) {
                    CharacterDetailsView(store: $0)
                }
            }
        }
    }
}

#Preview {
    RootView(store: Store(initialState: RootReducer.State()) { RootReducer() })
}
