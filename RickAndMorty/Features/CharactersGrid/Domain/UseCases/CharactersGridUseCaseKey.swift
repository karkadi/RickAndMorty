//
//  CharactersGridUseCaseKey.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys

enum CharactersGridUseCaseKey: DependencyKey {
    static let liveValue: CharactersGridUseCase = DefaultCharactersGridUseCase()
    static let testValue: CharactersGridUseCase = liveValue // MockCharactersGridUseCase()
    static let previewValue: CharactersGridUseCase = liveValue // MockCharactersGridUseCase()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var useCaseCharactersGrid: CharactersGridUseCase {
        get { self[CharactersGridUseCaseKey.self] }
        set { self[CharactersGridUseCaseKey.self] = newValue }
    }
}
