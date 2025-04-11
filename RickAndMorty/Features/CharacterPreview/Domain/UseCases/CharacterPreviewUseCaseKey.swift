//
//  CharacterPreviewUseCaseKey.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys

enum CharacterPreviewUseCaseKey: DependencyKey {
    static let liveValue: CharacterPreviewUseCase = DefaultCharacterPreviewUseCase()
    // static let testValue: CharacterPreviewUseCase = MockCharacterPreviewUseCase()
    // static let previewValue: CharacterPreviewUseCase = MockCharacterPreviewUseCase()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var useCaseCharacterPreview: CharacterPreviewUseCase {
        get { self[CharacterPreviewUseCaseKey.self] }
        set { self[CharacterPreviewUseCaseKey.self] = newValue }
    }
}
