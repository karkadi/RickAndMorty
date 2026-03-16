//
//  Info.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

struct Info: Codable, Sendable {
    let count: Int
    let pages: Int
    let next: String?
    let prev: String?
}
