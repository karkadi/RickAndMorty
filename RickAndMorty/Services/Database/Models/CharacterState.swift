//
//  CharacterState.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import SwiftData

@Model
class CharacterState {
    @Attribute(.unique) var id: Int
    var isSeen: Bool
    var isLiked: Bool

    init(id: Int, isSeen: Bool = false, isLiked: Bool = false) {
        self.id = id
        self.isSeen = isSeen
        self.isLiked = isLiked
    }
}
