//
//  CharacterPreviewRepository.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

protocol CharacterPreviewRepository {
    func fetchCharacterState(characterId: Int) async -> CharacterPreviewEntity?
}

class DefaultCharacterPreviewRepository: CharacterPreviewRepository {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    @MainActor
    func fetchCharacterState(characterId: Int) async -> CharacterPreviewEntity? {
        databaseService.fetchCharacterState(for: characterId)?.toCharacterPreviewEntity()
    }
}
