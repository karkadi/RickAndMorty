//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import CachedAsyncImage
import ComposableArchitecture
import SwiftUI

struct CharacterDetailsView: View {
    let store: StoreOf<CharacterDetailsReducer>

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                Spacer()
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
                        .aspectRatio(contentMode: .fill)
                        .transition(.scale)
                })
                .frame(width: 300, height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10.0 ))
                .transaction { transaction in
                    transaction.animation = .spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.025)
                }
                HStack {
                    Spacer()

                    Button {
                        store.send(.toggleLike)
                    } label: {
                        Label {
                            Text("Like")
                        } icon: {
                            Image(systemName: store.character.isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.red)
                        }
                        .labelStyle(.iconOnly)
                    }
                    .padding(.horizontal)
                }
                centeredText(title: "Status : ", text: store.character.status)
                centeredText(title: "Species : ", text: store.character.species)
                centeredText(title: "Type : ", text: store.character.type)
                centeredText(title: "Gender : ", text: store.character.gender)
                centeredText(title: "Created : ", text: store.character.created)
                Spacer()
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(store.character.name)
    }

    private func centeredText(title: String, text: String) -> some View {
        HStack(alignment: .center, spacing: 0.0 ) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(.textGreyColor)
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.textGreyColor)
        }
    }
}

struct PurpleTextColorLabelStyle: LabelStyle {
    func makeBody(configuration: Configuration) -> some View {
        Label(
            title: {
                configuration.title
            },
            icon: { configuration.icon
                .foregroundColor(.red)
            }
        )
    }
}

#Preview {
    if let character = MockRickAndMortyService.mockedCharacters?.results.first?.toEntity() {
        let store = Store(initialState: CharacterDetailsReducer.State(character: character)) {
            CharacterDetailsReducer()
        }
        NavigationStack {
            CharacterDetailsView(store: store)
        }
    } else {
        Text("No data available")
    }
}
