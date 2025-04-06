//
//  DependencyValues+StoryView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 18/03/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum DatabaseServiceKey: DependencyKey {
    static let liveValue: any DatabaseService = SwiftDataService()
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
