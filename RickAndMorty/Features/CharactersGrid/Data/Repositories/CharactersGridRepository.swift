//
//  CharactersGridRepository.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

protocol CharactersGridRepository {
    func fetchCharacters(from urlString: String) async throws -> RickAndMortyEntity
}

class DefaultCharactersGridRepository: CharactersGridRepository {
    @Dependency(\.networkService) private var networkService

    func fetchCharacters(from urlString: String) async throws -> RickAndMortyEntity {
        try await networkService.fetchCharacters(from: urlString).toEntity()
    }
}
