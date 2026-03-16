//
//  CharactersGridView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: CharactersGridReducer.self)
struct CharactersGridView: View {
    @Bindable var store: StoreOf<CharactersGridReducer>

    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation

    // Computed property for dynamic columns based on orientation
    private var columns: [GridItem] {
        let columnCount = orientation.isLandscape ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: columnCount)
    }

    var body: some View {
        ScrollView {
            if let error = store.error {
                errorView(error)
            } else {
                storyGrid
            }
        }
        .navigationTitle("Rick and Morty")
        .toolbarBackground(.bar, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    send(.navigateToAbout)
                } label: {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white)
                }
            }
        }
        .refreshable {
            send(.refresh)
        }
        .onAppear {
            send(.onAppear)
        }
        .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                orientation = UIDevice.current.orientation
            }
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
                send(.refresh)
            }
            .padding()
        }
    }

    private var storyGrid: some View {
        LazyVGrid(columns: columns, spacing: 15) {
            ForEach(store.state.characters) { character in
                NavigationLink(state:
                                RootReducer.Path.State.storyDetails(
                                    CharacterDetailsReducer.State(character: character)) ) {
                                                                      CharacterPreviewView(character: character)
                }
                                                                  .onAppear {
                                                                      if character.id == store.state.characters.last?.id {
                                                                          send(.loadMore)
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
    CharactersGridView(store: Store(initialState: CharactersGridReducer.State()) { CharactersGridReducer() }
    )
}
