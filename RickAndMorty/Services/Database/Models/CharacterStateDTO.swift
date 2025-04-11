//
//  CharacterStateDTO.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 10/04/2025.
//

// Sendable DTO for transferring data across actor boundaries
struct CharacterStateDTO: Sendable, Equatable {
    let id: Int
    var isSeen: Bool
    var isLiked: Bool

    init(id: Int, isSeen: Bool, isLiked: Bool) {
        self.id = id
        self.isSeen = isSeen
        self.isLiked = isLiked
    }

    init(from storyState: CharacterState) {
        self.id = storyState.id
        self.isSeen = storyState.isSeen
        self.isLiked = storyState.isLiked
    }
}
