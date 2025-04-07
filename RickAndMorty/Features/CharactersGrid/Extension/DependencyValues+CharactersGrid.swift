//
//  DependencyValues+CharactersGrid.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum CharactersGridRepositoryKey: DependencyKey {
    static let liveValue: any CharactersGridRepository = DefaultCharactersGridRepository(
        networkService: Dependency(\.networkService).wrappedValue
    )
 //   static let testValue: any CharactersGridRepository = MockCharactersGridRepository()
 //   static let previewValue: any CharactersGridRepository = MockCharactersGridRepository()
}

enum CharactersGridUseCaseKey: DependencyKey {
    static let liveValue: CharactersGridUseCase = DefaultCharactersGridUseCase(
        repository: Dependency(\.repositoryCharactersGrid).wrappedValue
    )
//    static let testValue: CharactersGridUseCase = MockCharactersGridUseCase()
 //   static let previewValue: CharactersGridUseCase = MockCharactersGridUseCase()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var repositoryCharactersGrid: any CharactersGridRepository {
        get { self[CharactersGridRepositoryKey.self] }
        set { self[CharactersGridRepositoryKey.self] = newValue }
    }

    var useCaseCharactersGrid: CharactersGridUseCase {
        get { self[CharactersGridUseCaseKey.self] }
        set { self[CharactersGridUseCaseKey.self] = newValue }
    }
}
