//
//  CharacterDetailsEntity.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

struct CharacterDetailsEntity: Equatable {
    var id: Int
    var isSeen: Bool = false
    var isLiked: Bool = false
}

extension CharacterDetailsEntity {
    func toDTO() -> CharacterStateDTO {
        CharacterStateDTO(id: id, isSeen: isSeen, isLiked: isLiked)
    }
}

extension CharacterStateDTO {
    func toCharacterDetailsEntity() -> CharacterDetailsEntity {
        CharacterDetailsEntity(id: id, isSeen: isSeen, isLiked: isLiked)
    }
}
