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
