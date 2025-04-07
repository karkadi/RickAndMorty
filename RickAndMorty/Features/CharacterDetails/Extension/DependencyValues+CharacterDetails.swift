//
//  DependencyValues+CharacterDetails.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum CharacterDetailsRepositoryKey: DependencyKey {
    static let liveValue: any CharacterDetailsRepository = DefaultCharacterDetailsRepository(
        databaseService: Dependency(\.databaseService).wrappedValue
    )
    //  static let testValue: any CharacterDetailsRepository = MockCharacterDetailsRepository()
    //  static let previewValue: any CharacterDetailsRepository = MockCharacterDetailsRepository()
}

enum CharacterDetailsUseCaseKey: DependencyKey {
    static let liveValue: CharacterDetailsUseCase = DefaultCharacterDetailsUseCase(
        repository: Dependency(\.repositoryCharacterDetails).wrappedValue
    )
    //  static let testValue: CharacterDetailsUseCase = MockCharacterDetailsUseCase()
    //  static let previewValue: CharacterDetailsUseCase = MockCharacterDetailsUseCase()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var repositoryCharacterDetails: any CharacterDetailsRepository {
        get { self[CharacterDetailsRepositoryKey.self] }
        set { self[CharacterDetailsRepositoryKey.self] = newValue }
    }

    var useCaseCharacterDetails: CharacterDetailsUseCase {
        get { self[CharacterDetailsUseCaseKey.self] }
        set { self[CharacterDetailsUseCaseKey.self] = newValue }
    }
}
