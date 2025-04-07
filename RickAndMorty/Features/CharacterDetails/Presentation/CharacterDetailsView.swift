//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import SwiftUI

struct CharacterDetailsView: View {
    @Environment(\.dismiss) var dismiss

    let store: StoreOf<CharacterDetailsFeature>

    init(character: ResultModelEntity) {
        self.store = Store(initialState: CharacterDetailsFeature.State(character: character)) { CharacterDetailsFeature() }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 8) {
                Spacer()
                AsyncImage(url: URL(string: store.character.image),
                           scale: 1,
                           transaction: Transaction(animation: .spring(
                            response: 0.5,
                            dampingFraction: 0.65,
                            blendDuration: 0.025))
                ) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 300, height: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 10.0 ))
                            .transition(.scale)
                    } else {
                        ProgressView()
                    }
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
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                })
            }
            ToolbarItem(placement: .principal) {
                Text(store.character.name)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    store.send(.toggleLike)
                }, label: {
                    Image(systemName: store.state.characterState?.isLiked ?? false ? "heart.fill" : "heart")
                        .foregroundColor(.red)
                })
            }
        }
        .toolbarBackground(.black.opacity(0.5), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
    }

    private func centeredText(title: String, text: String) -> some View {
        HStack(alignment: .center, spacing: 0.0 ) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            Text(text)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
        }
    }
}

#Preview {
    guard let character = MockRickAndMortyService.mockedCharacters?.results.first?.toEntity() else {
        return Text("No data available")
    }
    return NavigationView {
        CharacterDetailsView(character: character)
    }
}
