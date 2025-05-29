//
//  DatabaseClient.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//
import ComposableArchitecture
import Foundation
import SwiftData

// MARK: - Protocol
protocol DatabaseClient {
    func fetchCharacterState(for characterId: Int) async throws -> CharacterStateDTO?
    func updateCharacterState(_ state: CharacterStateDTO) async throws
 }

// MARK: - Live Implementation
actor SwiftDataService: DatabaseClient {
    private let modelContext: ModelContext

     init(modelContainer: ModelContainer) {
         self.modelContext = ModelContext(modelContainer)
     }

    enum DatabaseError: Error {
        case saveFailed
    }

    func fetchCharacterState(for characterId: Int) async throws -> CharacterStateDTO? {
        let predicate = #Predicate<CharacterState> { $0.id == characterId }
        let descriptor = FetchDescriptor<CharacterState>(predicate: predicate)
        guard let storyState = try modelContext.fetch(descriptor).first else {
            return nil
        }
        return CharacterStateDTO(from: storyState)
    }

    func updateCharacterState(_ state: CharacterStateDTO) async throws {
        let stateId = state.id
        let predicate = #Predicate<CharacterState> { $0.id == stateId }
        let descriptor = FetchDescriptor<CharacterState>(predicate: predicate)

        if let existingState = try modelContext.fetch(descriptor).first {
            // Update existing state
            existingState.isSeen = state.isSeen
            existingState.isLiked = state.isLiked
        } else {
            // Insert new state
            let newState = CharacterState(id: state.id, isSeen: state.isSeen, isLiked: state.isLiked)
            modelContext.insert(newState)
        }
        do {
            try modelContext.save()
        } catch {
            throw DatabaseError.saveFailed
        }
    }
}

// MARK: - Dependency Keys
enum DatabaseClientKey: DependencyKey {
    static let liveValue: any DatabaseClient = {
        do {
            let container = try ModelContainer(for: CharacterState.self)
            return SwiftDataService(modelContainer: container)
        } catch {
            fatalError("Failed to create test DatabaseService: \(error.localizedDescription)")
        }
    }()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var databaseClient: any DatabaseClient {
        get { self[DatabaseClientKey.self] }
        set { self[DatabaseClientKey.self] = newValue }
    }
}
