//
//  CharacterDetailsSnapshotTests 2.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2026.
//

import Testing
import DIContainer
@testable import RickAndMorty
import SwiftUI

@Suite("Character Details Snapshots")
@MainActor
final class CharacterDetailsSnapshotTests {
    
    let testContainer = DIContainer()
    let mockService = MockNetworkService()
    
    init() async throws {
        //  Register the Mock
        testContainer.register(NetworkServiceProtocol.self) { self.mockService }
        testContainer.register(DatabaseServiceProtocol.self) { MockDatabaseService() }
        testContainer.register(ImageCacheServiceProtocol.self) { MockImageCacheService() }
        
        // Inject it as the 'current' environment
        DIContainer.shared = testContainer
    }
    
    @Test
    @MainActor
    func characterDetailsDark() async throws {
        
        let character = createMockCharacter()
        let view = CharacterDetailsView(character: character)
        
        try await assertSnapshot(
            view,
            named: "CharacterDetails_dark",
            device: .iPhone15,
            colorScheme: .dark
        )
    }
    
    @Test
    @MainActor
    func characterDetailsLight() async throws {
        
        let character = createMockCharacter()
        let view = CharacterDetailsView(character: character)
        
        try await assertSnapshot(
            view,
            named: "CharacterDetails_light",
            device: .iPhone15,
            colorScheme: .light
        )
    }
    
    func createMockCharacter() -> Character {
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "Human",
            gender: "Male",
            image: "https://example.com/image.jpg",
            created: "2017-11-04T18:48:46.250Z",
            isSeen: false,
            isLiked: false
        )
    }
}
