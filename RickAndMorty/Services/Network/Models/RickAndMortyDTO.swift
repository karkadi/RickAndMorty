//
//  ResultModelDTO.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import Foundation

// MARK: - RickAndMorty
struct RickAndMortyDTO: Codable {
    let info: InfoDTO
    let results: [ResultModelDTO]
    
    enum CodingKeys: CodingKey {
        case info
        case results
    }
}
