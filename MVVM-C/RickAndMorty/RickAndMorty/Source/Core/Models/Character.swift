//
//  Character.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

struct Character: Identifiable, Equatable, Hashable, Sendable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let created: String
    var isSeen: Bool
    var isLiked: Bool
    
    init(id: Int, name: String, status: String, species: String, type: String, gender: String,
         image: String, created: String, isSeen: Bool = false, isLiked: Bool = false) {
        self.id = id
        self.name = name
        self.status = status
        self.species = species
        self.type = type
        self.gender = gender
        self.image = image
        self.created = created
        self.isSeen = isSeen
        self.isLiked = isLiked
    }
}
