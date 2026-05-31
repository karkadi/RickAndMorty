//
//  CharactersGridViewSnapshotTests.swift
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
final class CharactersGridViewSnapshotTests {
    
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
        
        let view = CharactersGridView(viewModel: CharactersGridViewModel())
        
        try await assertSnapshot(
            view,
            named: "CharactersGridView_dark",
            device: .iPhone15,
            colorScheme: .dark
        )
    }
    
    @Test
    @MainActor
    func characterDetailsLight() async throws {
        
        let view = CharactersGridView(viewModel: CharactersGridViewModel())
        
        try await assertSnapshot(
            view,
            named: "CharactersGridView_light",
            device: .iPhone15,
            colorScheme: .light
        )
    }
    
}
