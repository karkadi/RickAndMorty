//
//  CharacterDetailsViewModelTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//

import Testing
import Foundation
import DIContainer
@testable import RickAndMorty

@MainActor
final class CharacterDetailsViewModelTests {
    let testContainer = DIContainer()
    let mockDB = MockDatabaseService()
    
    init() async throws {
        //  Register the Mock
        testContainer.register(DatabaseServiceProtocol.self) { self.mockDB }
        testContainer.register(ImageCacheServiceProtocol.self) { MockImageCacheService() }
        
        // Inject it as the 'current' environment
        DIContainer.shared = testContainer
    }
    
    @Test("CharacterDetailsViewModel initializes correctly")
    func testInitialization() {
        let character = createMockCharacter()
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        #expect(viewModel.character.id == character.id)
        #expect(viewModel.character.name == character.name)
        #expect(viewModel.toggleLike == false)
        #expect(mockDB.fetchCharacterStateCallCount == 0)
    }
    
    @Test("CharacterDetailsViewModel toggles like state successfully")
    func testToggleLikeSuccess() async {
        // Given
        let character = createMockCharacter(isLiked: false)
        mockDB.shouldSucceed = true
        
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        // When
        await viewModel.toggleLike()
        
        // Then
        #expect(mockDB.toggleLikeCallCount == 1)
        #expect(mockDB.lastToggledCharacter?.id == character.id)
        #expect(viewModel.character.isLiked == true)
        #expect(viewModel.toggleLike == true)
    }
    
    @Test("CharacterDetailsViewModel toggles like state from liked to unliked")
    func testToggleLikeFromLikedToUnliked() async {
        // Given
        let character = createMockCharacter(isLiked: true)
        mockDB.shouldSucceed = true
        
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        // When
        await viewModel.toggleLike()
        
        // Then
        #expect(mockDB.toggleLikeCallCount == 1)
        #expect(viewModel.character.isLiked == false)
        #expect(viewModel.toggleLike == true)
    }
    
    @Test("CharacterDetailsViewModel handles toggle like failure gracefully")
    func testToggleLikeFailure() async {
        // Given
        let character = createMockCharacter(isLiked: false)
        mockDB.shouldSucceed = false
        
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        // When
        await viewModel.toggleLike()
        
        // Then
        #expect(mockDB.toggleLikeCallCount == 1)
        #expect(viewModel.character.isLiked == false) // Should remain unchanged
        #expect(viewModel.toggleLike == false)
        // Note: The error is printed but not stored in the ViewModel
    }
    
    @Test("CharacterDetailsViewModel marks as seen on appear successfully")
    func testOnAppearSuccess() async {
        // Given
        let character = createMockCharacter(isSeen: false)
        mockDB.shouldSucceed = true
        
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        // When
        await viewModel.onAppear()
        
        // Then
        #expect(mockDB.markAsSeenCallCount == 1)
        #expect(mockDB.lastSeenCharacter?.id == character.id)
        #expect(viewModel.character.isSeen == true)
    }
    
    @Test("CharacterDetailsViewModel doesn't change isSeen if already seen")
    func testOnAppearWhenAlreadySeen() async {
        // Given
        let character = createMockCharacter(isSeen: true)
        mockDB.shouldSucceed = true
        
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        // When
        await viewModel.onAppear()
        
        // Then
        #expect(mockDB.markAsSeenCallCount == 1)
        #expect(viewModel.character.isSeen == true) // Still true
    }
    
    @Test("CharacterDetailsViewModel handles mark as seen failure gracefully")
    func testOnAppearFailure() async {
        // Given
        let character = createMockCharacter(isSeen: false)
        mockDB.shouldSucceed = false
        
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        // When
        await viewModel.onAppear()
        
        // Then
        #expect(mockDB.markAsSeenCallCount == 1)
        #expect(viewModel.character.isSeen == false) // Should remain unchanged
    }
    
    @Test("CharacterDetailsViewModel updates character after multiple operations")
    func testMultipleOperations() async {
        // Given
        let character = createMockCharacter(isLiked: false, isSeen: false)
        let mockDB = MockDatabaseService()
        mockDB.shouldSucceed = true
      //  mockDB.markAsSeenCallCount = 0
     //   mockDB.toggleLikeCallCount = 0
        
        let viewModel = CharacterDetailsViewModel(
            character: character
        )
        
        // When - First mark as seen
        await viewModel.onAppear()
        #expect(viewModel.character.isSeen == true)
        #expect(viewModel.character.isLiked == false)
        
        // When - Then toggle like
        await viewModel.toggleLike()
        
        // Then
        #expect(viewModel.character.isSeen == true)
        #expect(viewModel.character.isLiked == true)
        #expect(mockDB.markAsSeenCallCount == 0)
        #expect(mockDB.toggleLikeCallCount == 0)
    }
    
    // Helper method to create mock character with customizable properties
    private func createMockCharacter(
        id: Int = 1,
        name: String = "Rick Sanchez",
        isLiked: Bool = false,
        isSeen: Bool = false
    ) -> Character {
        Character(
            id: id,
            name: name,
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://example.com/image.jpg",
            created: "2017-11-04T18:48:46.250Z",
            isSeen: isSeen,
            isLiked: isLiked
        )
    }
}
