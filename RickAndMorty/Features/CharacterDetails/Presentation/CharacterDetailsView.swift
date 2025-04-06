//
//  CharacterDetailsView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import SwiftUI
import ComposableArchitecture

struct CharacterDetailsView: View {
    @Environment(\.dismiss) var dismiss

    let store: StoreOf<CharacterDetailsFeature>

    init(user: ResultModelEntity) {
        self.store = Store(initialState: CharacterDetailsFeature.State(user: user),
                           reducer: { CharacterDetailsFeature() })
    }

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Spacer()
            AsyncImage(url: URL(string: store.user.image),
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
            CenteredText(title: "Status : ", text: store.user.status)
            CenteredText(title: "Species : ", text: store.user.species)
            CenteredText(title: "Type : ", text: store.user.type)
            CenteredText(title: "Gender : ", text: store.user.gender)
            CenteredText(title: "Created : ", text:  store.user.created)
            Spacer()
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
                Text(store.user.name)
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

    private func CenteredText(title: String, text: String) -> some View {
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
    guard let user = MockRickAndMortyService.mockedCharacters?.results.first?.toEntity() else {
        return Text("No data available")
    }
    return NavigationView {
        CharacterDetailsView(user: user)
    }
}
