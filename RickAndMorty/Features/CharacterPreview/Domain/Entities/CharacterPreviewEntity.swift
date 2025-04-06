//
//  CharacterPreviewEntity.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

struct CharacterPreviewEntity: Equatable {
    var isSeen: Bool
    var isLiked: Bool
}

extension CharacterState {
    func toCharacterPreviewEntity() -> CharacterPreviewEntity {
        CharacterPreviewEntity(isSeen: isSeen, isLiked: isLiked)
    }
}
