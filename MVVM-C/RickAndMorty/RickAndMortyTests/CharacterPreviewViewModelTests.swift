//
//  CharacterPreviewViewModelTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//
import Testing
@testable import RickAndMorty

@MainActor
struct CharacterPreviewViewModelTests {
    
    @Test("CharacterPreviewViewModel initializes correctly")
    func testInitialization() {
        let character = createMockCharacter()
        let viewModel = CharacterPreviewViewModel(character: character)
        
        #expect(viewModel.character.id == character.id)
        #expect(viewModel.character.name == character.name)
    }
    
    private func createMockCharacter() -> Character {
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://example.com/image.jpg",
            created: "2017-11-04T18:48:46.250Z",
            isSeen: false,
            isLiked: false
        )
    }
}
