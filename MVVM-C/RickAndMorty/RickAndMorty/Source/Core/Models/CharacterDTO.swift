//
//  CharacterDTO.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

struct CharacterDTO: Codable, Sendable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let gender: String
    let image: String
    let created: String
    
    func toCharacter(isSeen: Bool = false, isLiked: Bool = false) -> Character {
        Character(
            id: id,
            name: name,
            status: status,
            species: species,
            type: type,
            gender: gender,
            image: image,
            created: created,
            isSeen: isSeen,
            isLiked: isLiked
        )
    }
}
