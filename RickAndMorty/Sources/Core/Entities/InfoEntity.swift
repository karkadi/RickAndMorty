//
//  InfoEntity.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import Foundation

// MARK: - Info
struct InfoEntity: Equatable {
    let next: String?
}

extension InfoDTO {
    func toEntity() -> InfoEntity {
        InfoEntity(next: next)
    }
}
