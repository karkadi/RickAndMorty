//
//  CharacterDetailsClient.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 27/05/2025.
//
import ComposableArchitecture

// MARK: - Protocol
protocol CharacterDetailsClientProtocol {
    func fetchCharacterState(for entry: ResultModelEntity) async throws -> ResultModelEntity
    func markStoryAsSeen(for entry: ResultModelEntity) async throws -> ResultModelEntity
    func toggleStoryLike(for entry: ResultModelEntity) async throws -> ResultModelEntity
}

// MARK: - Live Implementation
final class CharacterDetailsClient: CharacterDetailsClientProtocol {
    // MARK: - Dependencies
    @Dependency(\.databaseClient) private var databaseClient

    func fetchCharacterState(for entry: ResultModelEntity) async throws -> ResultModelEntity {
        var updatedStory = entry
        if let state = try await databaseClient.fetchCharacterState(for: entry.id) {
            updatedStory.isLiked = state.isLiked
            updatedStory.isSeen = state.isSeen
        }
        return updatedStory
    }

    func markStoryAsSeen(for entry: ResultModelEntity) async throws -> ResultModelEntity {
        var updatedEntry = entry
        updatedEntry.isSeen = true
        try await databaseClient.updateCharacterState(updatedEntry.toDTO())
        return updatedEntry
    }
    func toggleStoryLike(for entry: ResultModelEntity) async throws -> ResultModelEntity {
        var updatedStory = entry
        updatedStory.isLiked.toggle()
        try await databaseClient.updateCharacterState(updatedStory.toDTO())
        return updatedStory
    }
}

// MARK: - Dependency Keys
enum CharacterDetailsClientKey: DependencyKey {
    static let liveValue: any CharacterDetailsClientProtocol = CharacterDetailsClient()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var characterDetailsClient: CharacterDetailsClientProtocol {
        get { self[CharacterDetailsClientKey.self] }
        set { self[CharacterDetailsClientKey.self] = newValue }
    }
}
