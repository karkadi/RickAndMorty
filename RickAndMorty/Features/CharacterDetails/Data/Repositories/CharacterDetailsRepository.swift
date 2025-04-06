//
//  CharacterDetailsRepository.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

protocol CharacterDetailsRepository {
    func fetchCharacterState(characterId: Int) async -> CharacterDetailsEntity?
    func updateStory(_ story: CharacterDetailsEntity) async
}

class DefaultCharacterDetailsRepository: CharacterDetailsRepository {
    private let databaseService: DatabaseService

    init(databaseService: DatabaseService) {
        self.databaseService = databaseService
    }

    @MainActor
    func fetchCharacterState(characterId: Int) async -> CharacterDetailsEntity? {
        databaseService.fetchCharacterState(for: characterId)?.toCharacterDetailsEntity()
    }
    @MainActor
    func updateStory(_ story: CharacterDetailsEntity) async {
         databaseService.updateCharacterState(story.toDTO())
    }
}
