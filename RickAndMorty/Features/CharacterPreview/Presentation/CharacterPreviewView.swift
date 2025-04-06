//
//  CharacterPreviewView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import SwiftUI
import ComposableArchitecture

struct CharacterPreviewView: View {
    let store: StoreOf<CharacterPreviewFeature>

    init(user: ResultModelEntity) {
        self.store = Store(initialState: CharacterPreviewFeature.State(user: user),
                           reducer: { CharacterPreviewFeature() })
    }

    var body: some View {
        NavigationLink {
            CharacterDetailsView(user: store.user)
        } label: {
            VStack(spacing: 8) {
                ZStack(alignment: .bottomTrailing) {
                    AsyncImage(url: URL(string: store.user.image)) { image in
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

                Text(store.user.name)
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
    guard let user = MockRickAndMortyService.mockedCharacters?.results.first?.toEntity() else {
        return Text("No data available")
    }
    return CharacterPreviewView(user: user)
}
