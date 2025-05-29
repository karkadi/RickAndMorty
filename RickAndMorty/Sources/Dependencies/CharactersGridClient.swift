//
//  CharacterDetailsClient.swift
//  TCATestApp
//
//  Created by Arkadiy KAZAZYAN on 27/05/2025.
//
import ComposableArchitecture

// MARK: - Protocol
protocol CharacterDetailsClient {
    func fetchCharacterState(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity
    func markStoryAsSeen(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity
    func toggleStoryLike(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity
}

// MARK: - Live Implementation
final class DefaultCharacterDetailsClient: CharacterDetailsClient {
    // MARK: - Dependencies
    @Dependency(\.databaseClient) private var databaseClient

    func fetchCharacterState(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity {
        var updatedStory = entry
        if let state = try await databaseClient.fetchCharacterState(for: entry.id) {
            updatedStory.isLiked = state.isLiked
            updatedStory.isSeen = state.isSeen
        }
        return updatedStory
    }

    func markStoryAsSeen(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity {
        var updatedEntry = entry
        updatedEntry.isSeen = true
        try await databaseClient.updateCharacterState(updatedEntry.toDTO())
        return updatedEntry
    }
    func toggleStoryLike(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity {
        var updatedStory = entry
        updatedStory.isLiked.toggle()
        try await databaseClient.updateCharacterState(updatedStory.toDTO())
        return updatedStory
    }
}

// MARK: - Dependency Keys
enum CharacterDetailsClientKey: DependencyKey {
    static let liveValue: any CharacterDetailsClient = DefaultCharacterDetailsClient()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var characterDetailsClient: CharacterDetailsClient {
        get { self[CharacterDetailsClientKey.self] }
        set { self[CharacterDetailsClientKey.self] = newValue }
    }
}
