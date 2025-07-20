//
//  CharacterPreviewView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import CachedAsyncImage
import ComposableArchitecture
import SwiftUI

struct CharacterPreviewView: View {
    let store: StoreOf<CharacterPreviewReducer>

    init(character: ResultModelEntity) {
        self.store = Store(initialState:
                            CharacterPreviewReducer.State(character: character)) {
            CharacterPreviewReducer()
        }
    }

    var body: some View {
            VStack(spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    CachedAsyncImage(url: store.character.image,
                                     placeholder: { progress in
                        ZStack {
                            Color.background
                            ProgressView {
                                VStack {
                                    Text("Loading...")
                                    Text("\(progress) %")
                                }
                            }
                        }
                    },
                                     image: {
                        Image(uiImage: $0)
                            .resizable()
                            .scaledToFill()
                    })
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(store.character.isSeen ? Color.gray : Color.blue, lineWidth: 2)
                    )
                    if store.character.isLiked {
                        Image(systemName: "heart.fill" )
                            .foregroundColor(.red)
                    }
                }
                .frame(width: 100, height: 100)

                Text(store.character.name)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    guard let character = MockRickAndMortyService.mockedCharacters?.results.first?.toEntity() else {
        return Text("No data available")
    }
    return CharacterPreviewView(character: character)
}
