//
//  CharacterDetailsEntity.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

struct CharacterDetailsEntity : Equatable {
    var id: Int
    var isSeen: Bool
    var isLiked: Bool
}

extension CharacterDetailsEntity {
    func toDTO() -> CharacterState {
        CharacterState(id: id, isSeen: isSeen, isLiked: isLiked)
    }
}

extension CharacterState {
    func toCharacterDetailsEntity() -> CharacterDetailsEntity {
        CharacterDetailsEntity(id: id, isSeen: isSeen, isLiked: isLiked)
    }
}
