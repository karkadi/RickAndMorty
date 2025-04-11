//
//  CharacterPreviewEntity.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

struct CharacterPreviewEntity: Equatable {
    var id: Int
    var isSeen: Bool
    var isLiked: Bool
}

extension CharacterStateDTO {
    func toCharacterPreviewEntity() -> CharacterPreviewEntity {
        CharacterPreviewEntity(id: id, isSeen: isSeen, isLiked: isLiked)
    }
}
