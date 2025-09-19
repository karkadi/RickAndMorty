//
//  DatabaseClient.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 27/05/2025.
//
import ComposableArchitecture
import SQLiteData

// MARK: - Protocol
protocol DatabaseClient {
    func fetchCharacterState(for entry: ResultModelEntity) async throws -> ResultModelEntity
    func markStoryAsSeen(for entry: ResultModelEntity) async throws -> ResultModelEntity
    func toggleStoryLike(for entry: ResultModelEntity) async throws -> ResultModelEntity
}

// MARK: - Live Implementation
final class DefaultDatabaseClient: DatabaseClient {
    // MARK: - Dependencies
    @Dependency(\.defaultDatabase) private var database

    func fetchCharacterState(for entry: ResultModelEntity) async throws -> ResultModelEntity {
        var updatedStory = entry
        if let state = try await fetchSqlState(for: entry.id) {
            updatedStory.isLiked = state.isLiked
            updatedStory.isSeen = state.isSeen
        }
        return updatedStory
    }

    func markStoryAsSeen(for entry: ResultModelEntity) async throws -> ResultModelEntity {
        var updatedEntry = entry
        updatedEntry.isSeen = true
        try await upsertStoryState(updatedEntry.toDTO())
        return updatedEntry
    }
    func toggleStoryLike(for entry: ResultModelEntity) async throws -> ResultModelEntity {
        var updatedStory = entry
        updatedStory.isLiked.toggle()
        try await upsertStoryState(updatedStory.toDTO())
        return updatedStory
    }

    private func upsertStoryState(_ state: CharacterState) async throws {
        do {
            try await database.write { sqlDb in
                try CharacterState.upsert { state }
                    .execute(sqlDb)
            }
        } catch {
            print(error)
        }
    }

    private func fetchSqlState(for id: Int) async throws -> CharacterState? {
        var result: CharacterState?
        do {
            result = try await database.read { sqlDb in
                try CharacterState
                    .where { $0.id.eq(id) }
                    .fetchOne(sqlDb)
            }
        } catch {
            print(error)
        }
        return result
    }
}

// MARK: - Dependency Keys
enum DatabaseClientKey: DependencyKey {
    static let liveValue: any DatabaseClient = DefaultDatabaseClient()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}
