//
//  ModelTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//
import Testing
@testable import RickAndMorty

// MARK: - Model Tests
struct ModelTests {
    
    @Test("Character initialization works correctly")
    func testCharacterInitialization() {
        let character = Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            created: "2017-11-04T18:48:46.250Z",
            isSeen: false,
            isLiked: false
        )
        
        #expect(character.id == 1)
        #expect(character.name == "Rick Sanchez")
        #expect(character.status == "Alive")
        #expect(character.species == "Human")
        #expect(character.type == "")
        #expect(character.gender == "Male")
        #expect(character.isSeen == false)
        #expect(character.isLiked == false)
    }
    
    @Test("Character DTO conversion works correctly")
    func testCharacterDTOConversion() {
        let dto = CharacterDTO(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
            created: "2017-11-04T18:48:46.250Z"
        )
        
        let character = dto.toCharacter(isSeen: true, isLiked: true)
        
        #expect(character.id == dto.id)
        #expect(character.name == dto.name)
        #expect(character.status == dto.status)
        #expect(character.species == dto.species)
        #expect(character.type == dto.type)
        #expect(character.gender == dto.gender)
        #expect(character.image == dto.image)
        #expect(character.created == dto.created)
        #expect(character.isSeen == true)
        #expect(character.isLiked == true)
    }
}
