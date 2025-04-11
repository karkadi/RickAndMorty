//
//  CharacterPreviewRepository.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

protocol CharacterPreviewRepository {
    func fetchCharacterState(for entry: inout CharacterPreviewEntity) async throws
}

class DefaultCharacterPreviewRepository: CharacterPreviewRepository {
    @Dependency(\.databaseService) private var databaseService

    func fetchCharacterState(for entry: inout CharacterPreviewEntity) async throws {
        let characterId = entry.id
        if let state = try await databaseService.fetchCharacterState(for: characterId) {
            entry.isLiked = state.isLiked
            entry.isSeen = state.isSeen
        }
    }
}
