//
//  SwiftDataModelTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//
import Testing
import Foundation
@testable import RickAndMorty

// MARK: - SwiftData Model Tests
@MainActor
struct SwiftDataModelTests {
    
    @Test("LikedCharacter model initializes correctly")
    func testLikedCharacterInitialization() {
        let likedCharacter = LikedCharacter(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://example.com/image.jpg",
            created: "2017-11-04T18:48:46.250Z",
            isLiked: true,
            isSeen: true
        )
        
        #expect(likedCharacter.id == 1)
        #expect(likedCharacter.name == "Rick Sanchez")
        #expect(likedCharacter.isLiked == true)
        #expect(likedCharacter.isSeen == true)
    }
    
    @Test("CachedImage model initializes correctly")
    func testCachedImageInitialization() {
        let imageData = Data()
        let cachedImage = CachedImage(
            url: "https://example.com/image.jpg",
            imageData: imageData
        )
        
        #expect(cachedImage.url == "https://example.com/image.jpg")
        #expect(cachedImage.imageData == imageData)
        #expect(cachedImage.lastAccessed.timeIntervalSinceNow < 1)
    }
}
