//
//  CharacterDetailsUseCase.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

protocol CharacterDetailsUseCase {
    func fetchCharacterState(for characterId: Int) async -> CharacterDetailsEntity?
    func markStoryAsSeen(characterId: Int, currentStory: CharacterDetailsEntity?) async
    func toggleStoryLike(characterId: Int, currentStory: CharacterDetailsEntity?) async
}

class DefaultCharacterDetailsUseCase: CharacterDetailsUseCase {
    private let repository: CharacterDetailsRepository

    init(repository: CharacterDetailsRepository) {
        self.repository = repository
    }

    func fetchCharacterState(for characterId: Int) async -> CharacterDetailsEntity? {
        await repository.fetchCharacterState(characterId: characterId)
    }

    func markStoryAsSeen(characterId: Int, currentStory: CharacterDetailsEntity?) async {
        if let story = currentStory {
            var updatedStory = story
            updatedStory.isSeen = true
            await repository.updateStory(updatedStory)
        } else {
            let newStory = CharacterDetailsEntity(id: characterId, isSeen: true, isLiked: false)
            await repository.updateStory(newStory)
        }
    }

    func toggleStoryLike(characterId: Int, currentStory: CharacterDetailsEntity?) async {
        if let story = currentStory {
            var updatedStory = story
            updatedStory.isLiked.toggle()
            await repository.updateStory(updatedStory)
        } else {
            let newStory = CharacterDetailsEntity(id: characterId, isSeen: false, isLiked: true)
            await repository.updateStory(newStory)
        }
    }
}
