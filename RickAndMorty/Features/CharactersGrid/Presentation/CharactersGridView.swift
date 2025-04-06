//
//  CharactersGridView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import SwiftUI
import ComposableArchitecture

struct CharactersGridView: View {
    let store: StoreOf<CharactersGridFeature>
    
    init() {
        self.store = Store(initialState: CharactersGridFeature.State(),
                           reducer: { CharactersGridFeature() })
    }
    
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if let error = store.error {
                    errorView(error)
                } else {
                    storyGrid
                }
            }
            .navigationTitle("Rick and Morty")
            .refreshable {
                store.send(.refresh)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
    
    @ViewBuilder
    private func errorView(_ error: Error) -> some View {
        VStack {
            Text("Error loading stories")
                .foregroundColor(.red)
            Text(error.localizedDescription)
                .font(.caption)
            Button("Retry") {
                store.send(.refresh)
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var storyGrid: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(store.state.characters) { character in
                CharacterPreviewView(user: character)
                    .onAppear {
                        if character.id == store.state.characters.last?.id {
                            store.send(.loadMore)
                        }
                    }
            }
            
            if store.state.isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    CharactersGridView()
}
