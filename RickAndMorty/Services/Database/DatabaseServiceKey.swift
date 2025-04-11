//
//  DatabaseServiceKey.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 18/03/2025.
//

import ComposableArchitecture
import SwiftData

// MARK: - Dependency Keys
enum DatabaseServiceKey: DependencyKey {
    static let liveValue: any DatabaseService = {
        do {
            let container = try ModelContainer(for: CharacterState.self)
            return SwiftDataService(modelContainer: container)
        } catch {
            fatalError("Failed to create test DatabaseService: \(error.localizedDescription)")
        }
    }()
    static let testValue: any DatabaseService = MockDatabaseService()
    static let previewValue: any DatabaseService = MockDatabaseService()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var databaseService: any DatabaseService {
        get { self[DatabaseServiceKey.self] }
        set { self[DatabaseServiceKey.self] = newValue }
    }
}
