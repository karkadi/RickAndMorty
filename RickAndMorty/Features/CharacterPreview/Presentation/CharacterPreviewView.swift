//
//  CharacterPreviewView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import SwiftUI

struct CharacterPreviewView: View {
    let store: StoreOf<CharacterPreviewFeature>

    init(character: ResultModelEntity) {
        self.store = Store(initialState: CharacterPreviewFeature.State(character: character)) { CharacterPreviewFeature() }
    }

    var body: some View {
        NavigationLink {
            CharacterDetailsView(character: store.character)
        } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: store.character.image)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(store.isSeen ? Color.gray : Color.blue, lineWidth: 2)
                    )
                    if store.isLiked {
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
