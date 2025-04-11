//
//  CharacterDetailsRepositoryKey.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum CharacterDetailsRepositoryKey: DependencyKey {
    static let liveValue: any CharacterDetailsRepository = DefaultCharacterDetailsRepository()
    // static let testValue: any CharacterDetailsRepository = MockCharacterDetailsRepository()
    // static let previewValue: any CharacterDetailsRepository = MockCharacterDetailsRepository()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var repositoryCharacterDetails: any CharacterDetailsRepository {
        get { self[CharacterDetailsRepositoryKey.self] }
        set { self[CharacterDetailsRepositoryKey.self] = newValue }
    }
}
