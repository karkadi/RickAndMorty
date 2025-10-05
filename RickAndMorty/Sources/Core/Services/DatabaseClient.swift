//
//  DatabaseClient.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 27/05/2025.
//
import ComposableArchitecture
import SQLiteData

// MARK: - Protocol
struct DatabaseClient: Sendable {
    var fetchCharacterState: @Sendable(_ entry: ResultModelEntity) async throws -> ResultModelEntity
    var markStoryAsSeen: @Sendable(_ entry: ResultModelEntity) async throws -> ResultModelEntity
    var toggleStoryLike: @Sendable(_ entry: ResultModelEntity) async throws -> ResultModelEntity
}

// MARK: - Live Implementation
extension DatabaseClient: DependencyKey {
    static let liveValue: DatabaseClient = {
        @Dependency(\.defaultDatabase) var database
        
        return DatabaseClient(
            fetchCharacterState: { entry in
                var updatedStory = entry
                if let state = try await fetchSqlState(database, entry.id) {
                    updatedStory.isLiked = state.isLiked
                    updatedStory.isSeen = state.isSeen
                }
                return updatedStory
            },
            markStoryAsSeen: { entry in
                var updatedEntry = entry
                updatedEntry.isSeen = true
                try await upsertStoryState(database, updatedEntry.toDTO())
                return updatedEntry
            },
            toggleStoryLike: { entry in
                var updatedStory = entry
                updatedStory.isLiked.toggle()
                try await upsertStoryState(database, updatedStory.toDTO())
                return updatedStory
            }
        )
    }()
}

private func upsertStoryState(_ database: DatabaseWriter, _ state: CharacterState) async throws {
    do {
        try await database.write { sqlDb in
            try CharacterState.upsert { state }
                .execute(sqlDb)
        }
    } catch {
        print(error)
        throw(error)
    }
}

private func fetchSqlState(_ database: DatabaseWriter, _ id: Int) async throws -> CharacterState? {
    var result: CharacterState?
    do {
        result = try await database.read { sqlDb in
            try CharacterState
                .where { $0.id.eq(id) }
                .fetchOne(sqlDb)
        }
    } catch {
        print(error)
        throw(error)
    }
    return result
}

// MARK: - Dependency Registration
extension DependencyValues {
    var databaseClient: DatabaseClient {
        get { self[DatabaseClient.self] }
        set { self[DatabaseClient.self] = newValue }
    }
}
