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
    
    let mockService = MockNetworkService()
    
    @MainActor
    init() async throws {
        DependencyOverrideStore.shared.override(\.databaseService, with: MockDatabaseService())
        DependencyOverrideStore.shared.override(\.imageCacheService, with: MockImageCacheService())
        DependencyOverrideStore.shared.override(\.networkService, with: mockService)
    }
    
    deinit {
        Task { @MainActor in DependencyOverrideStore.shared.reset() }
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
