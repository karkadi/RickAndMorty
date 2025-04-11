//
//  CharacterDetailsRepository.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

protocol CharacterDetailsRepository {
    func fetchCharacterState(for entry: inout CharacterDetailsEntity) async throws
    func updateStory(_ story: CharacterDetailsEntity) async throws
}

class DefaultCharacterDetailsRepository: CharacterDetailsRepository {
    @Dependency(\.databaseService) private var databaseService

    func fetchCharacterState(for entry: inout CharacterDetailsEntity) async throws {
        let characterId = entry.id
        if let state = try await databaseService.fetchCharacterState(for: characterId) {
            entry.isLiked = state.isLiked
            entry.isSeen = state.isSeen
        }
    }

    func updateStory(_ story: CharacterDetailsEntity) async throws {
        try await databaseService.updateCharacterState(story.toDTO())
    }
}
