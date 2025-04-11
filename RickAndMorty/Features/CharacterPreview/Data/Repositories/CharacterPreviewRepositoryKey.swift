//
//  CharacterPreviewRepositoryKey.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum CharacterPreviewRepositoryKey: DependencyKey {
    static let liveValue: any CharacterPreviewRepository = DefaultCharacterPreviewRepository()
    // static let testValue: any CharacterPreviewRepository = MockCharacterPreviewRepository()
    // static let previewValue: any CharacterPreviewRepository = MockCharacterPreviewRepository()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var repositoryCharacterPreview: any CharacterPreviewRepository {
        get { self[CharacterPreviewRepositoryKey.self] }
        set { self[CharacterPreviewRepositoryKey.self] = newValue }
    }
}
