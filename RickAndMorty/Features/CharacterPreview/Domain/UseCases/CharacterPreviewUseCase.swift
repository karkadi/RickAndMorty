//
//  CharacterPreviewUseCase.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

protocol CharacterPreviewUseCase {
    func fetchCharacterState(for characterId: Int) async -> CharacterPreviewEntity?
}

class DefaultCharacterPreviewUseCase: CharacterPreviewUseCase {
    private let repository: CharacterPreviewRepository

    init(repository: CharacterPreviewRepository) {
        self.repository = repository
    }

    func fetchCharacterState(for characterId: Int) async -> CharacterPreviewEntity? {
        await repository.fetchCharacterState(characterId: characterId)
    }
}
