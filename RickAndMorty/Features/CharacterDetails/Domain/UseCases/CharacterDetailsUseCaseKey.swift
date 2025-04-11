//
//  CharacterDetailsRepositoryKey.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys

enum CharacterDetailsUseCaseKey: DependencyKey {
    static let liveValue: CharacterDetailsUseCase = DefaultCharacterDetailsUseCase()
    // static let testValue: CharacterDetailsUseCase = MockCharacterDetailsUseCase()
    // static let previewValue: CharacterDetailsUseCase = MockCharacterDetailsUseCase()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var useCaseCharacterDetails: CharacterDetailsUseCase {
        get { self[CharacterDetailsUseCaseKey.self] }
        set { self[CharacterDetailsUseCaseKey.self] = newValue }
    }
}
