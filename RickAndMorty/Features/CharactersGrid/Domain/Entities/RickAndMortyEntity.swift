//
//  RickAndMortyEntity.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

struct RickAndMortyEntity: Equatable {
    let info: InfoEntity
    let results: [ResultModelEntity]
}

extension RickAndMortyDTO {
    func toEntity() -> RickAndMortyEntity {
        RickAndMortyEntity(info: info.toEntity(),
                           results: results.map{ $0.toEntity() } )
    }
}
