//
//  CharactersGridView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import SwiftUI

@ViewAction(for: CharactersGridFeature.self)
struct CharactersGridView: View {
    @Bindable var store: StoreOf<CharactersGridFeature>

    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var orientation: UIDeviceOrientation = UIDevice.current.orientation

    init() {
        self.store = Store(initialState: CharactersGridFeature.State()) { CharactersGridFeature() }
    }

    // Computed property for dynamic columns based on orientation
    private var columns: [GridItem] {
        let columnCount = orientation.isLandscape ? 4 : 2
        return Array(repeating: GridItem(.flexible(), spacing: 15), count: columnCount)
    }

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            ScrollView {
                if let error = store.error {
                    errorView(error)
                } else {
                    storyGrid
                }
            }
            .navigationTitle("Rick and Morty")
            .refreshable {
                send(.refresh)
            }
        } destination: { destination in
            switch destination.case {
            case let .storyDetails(detailsStore):
                CharacterDetailsView(store: detailsStore)
            }
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
                                CharactersGridFeature.Path.State.storyDetails(
                                    CharacterDetailsFeature.State(character: character,
                                                                  entiryState: .init(id: character.id))) ) {
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
    CharactersGridView()
}
