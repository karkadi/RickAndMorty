//
//  CharacterPreviewUseCase.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

protocol CharacterPreviewUseCase {
    func fetchCharacterState(for entry: CharacterPreviewEntity) async throws -> CharacterPreviewEntity
}

class DefaultCharacterPreviewUseCase: CharacterPreviewUseCase {
    @Dependency(\.repositoryCharacterPreview) private var repository

    func fetchCharacterState(for entry: CharacterPreviewEntity) async throws -> CharacterPreviewEntity {
        var updatedStory = entry
        try await repository.fetchCharacterState(for: &updatedStory)
        return updatedStory
    }
}
