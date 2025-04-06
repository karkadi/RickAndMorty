//
//  DependencyValues+CharacterPreview.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum CharacterPreviewRepositoryKey: DependencyKey {
    static let liveValue: any CharacterPreviewRepository = DefaultCharacterPreviewRepository(
        databaseService: Dependency(\.databaseService).wrappedValue
    )
 //   static let testValue: any CharacterPreviewRepository = MockCharacterPreviewRepository()
  //  static let previewValue: any CharacterPreviewRepository = MockCharacterPreviewRepository()
}

enum CharacterPreviewUseCaseKey: DependencyKey {
    static let liveValue: CharacterPreviewUseCase = DefaultCharacterPreviewUseCase(
        repository: Dependency(\.repositoryCharacterPreview).wrappedValue
    )
  //  static let testValue: CharacterPreviewUseCase = MockCharacterPreviewUseCase()
   // static let previewValue: CharacterPreviewUseCase = MockCharacterPreviewUseCase()
}

// MARK: - Dependency Registration
extension DependencyValues {

    var repositoryCharacterPreview: any CharacterPreviewRepository {
        get { self[CharacterPreviewRepositoryKey.self] }
        set { self[CharacterPreviewRepositoryKey.self] = newValue }
    }

    var useCaseCharacterPreview: CharacterPreviewUseCase {
        get { self[CharacterPreviewUseCaseKey.self] }
        set { self[CharacterPreviewUseCaseKey.self] = newValue }
    }
}
