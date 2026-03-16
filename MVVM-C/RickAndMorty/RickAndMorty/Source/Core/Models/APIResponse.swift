//
//  APIResponse.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// Make DTOs Sendable for concurrency
struct APIResponse: Codable, Sendable {
    let info: Info
    let results: [CharacterDTO]
}
