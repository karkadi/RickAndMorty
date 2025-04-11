//
//  DependencyValues+CharactersGrid.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum CharactersGridRepositoryKey: DependencyKey {
    static let liveValue: any CharactersGridRepository = DefaultCharactersGridRepository()
    static let testValue: any CharactersGridRepository = liveValue // MockCharactersGridRepository()
    static let previewValue: any CharactersGridRepository = liveValue // MockCharactersGridRepository()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var repositoryCharactersGrid: any CharactersGridRepository {
        get { self[CharactersGridRepositoryKey.self] }
        set { self[CharactersGridRepositoryKey.self] = newValue }
    }
}
