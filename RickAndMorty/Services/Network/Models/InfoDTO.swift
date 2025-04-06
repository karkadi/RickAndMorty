//
//  InfoDTO.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import Foundation

// MARK: - Info
struct InfoDTO: Codable {
    let count, pages: Int
    let next: String?
    let prev: String?
    
    enum CodingKeys: CodingKey {
        case count
        case pages
        case next
        case prev
    }
}
