//
//  CharacterDetailsUseCase.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//
import ComposableArchitecture

protocol CharacterDetailsUseCase {
    func fetchCharacterState(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity
    func markStoryAsSeen(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity
    func toggleStoryLike(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity
}

class DefaultCharacterDetailsUseCase: CharacterDetailsUseCase {
    @Dependency(\.repositoryCharacterDetails) private var repository

    func fetchCharacterState(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity {
        var updatedStory = entry
        try await repository.fetchCharacterState(for: &updatedStory)
        return updatedStory
    }

    func markStoryAsSeen(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity {
        var updatedStory = entry
        updatedStory.isSeen = true
        try await repository.updateStory(updatedStory)
        return updatedStory
    }

    func toggleStoryLike(for entry: CharacterDetailsEntity) async throws -> CharacterDetailsEntity {
        var updatedStory = entry
        updatedStory.isLiked.toggle()
        try await repository.updateStory(updatedStory)
        return updatedStory
    }
}
