//
//  MockDatabaseService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//

import Testing
import Foundation
@testable import RickAndMorty

// MARK: - Mock Database Service
@MainActor
final class MockDatabaseService: DatabaseServiceProtocol {
    var shouldSucceed = true
    var fetchCharacterStateCallCount = 0
    var toggleLikeCallCount = 0
    var markAsSeenCallCount = 0
    
    // Store the last character that was modified
    var lastToggledCharacter: Character?
    var lastSeenCharacter: Character?
    
    func fetchCharacterState(_ character: Character) async throws -> Character {
        fetchCharacterStateCallCount += 1
        
        if shouldSucceed {
            return character
        } else {
            throw NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Fetch failed"])
        }
    }
    
    func toggleLike(for character: Character) async throws -> Character {
        toggleLikeCallCount += 1
        lastToggledCharacter = character
        
        if shouldSucceed {
            var updatedCharacter = character
            updatedCharacter.isLiked.toggle()
            return updatedCharacter
        } else {
            throw NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Toggle like failed"])
        }
    }
    
    func markAsSeen(_ character: Character) async throws -> Character {
        markAsSeenCallCount += 1
        lastSeenCharacter = character
        
        if shouldSucceed {
            var updatedCharacter = character
            updatedCharacter.isSeen = true
            return updatedCharacter
        } else {
            throw NSError(domain: "test", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mark as seen failed"])
        }
    }
}
