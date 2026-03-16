//
//  LikedCharacter.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Model
import Foundation
import SwiftData

@Model
final class LikedCharacter {
    @Attribute(.unique) var id: Int
    var name: String
    var status: String
    var species: String
    var type: String
    var gender: String
    var image: String
    var created: String
    var isLiked: Bool
    var isSeen: Bool
    
    init(id: Int, name: String, status: String, species: String, type: String, gender: String,
         image: String, created: String, isLiked: Bool = false, isSeen: Bool = false) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.image = image
        self.created = created
        self.isLiked = isLiked
        self.isSeen = isSeen
    }
}
