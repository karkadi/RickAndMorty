//
//  CharacterPreviewView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import SwiftUI

struct CharacterPreviewView: View {
    @State var character: Character
    @State private var viewModel: CharacterPreviewViewModel

    init(character: Character) {
        self.character = character
        self._viewModel = State(initialValue: CharacterPreviewViewModel(character: character))
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack(alignment: .bottomLeading) {
                if let image = viewModel.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(viewModel.character.isSeen ? Color.gray : Color.blue, lineWidth: 2)
                        )
                } else {
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 100)
                        .overlay(
                            ProgressView()
                                .tint(.white)
                        )
                }
                
                if viewModel.character.isLiked {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .background(
                            Circle()
                                .fill(Color.black)
                                .frame(width: 24, height: 24)
                        )
                        .offset(x: 0, y: 0)
                }
            }
            
            Text(viewModel.character.name)
                .font(.caption)
                .lineLimit(1)
                .foregroundColor(.white)
        }
        .task {
            await viewModel.onAppear()
        }
        .onChange(of: viewModel.character) { _, newValue in
            character = newValue
        }
    }
}

#Preview {
    guard let character = MockData.mockedCharacters?.results.first?.toCharacter() else {
        return Text("No data available")
    }
    return CharacterPreviewView(character: character)
        .preferredColorScheme(.dark)
}
