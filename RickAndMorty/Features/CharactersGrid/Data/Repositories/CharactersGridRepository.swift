//
//  CharactersGridRepository.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

protocol CharactersGridRepository {
    func fetchCharacters(from urlString: String) async throws -> RickAndMortyEntity
}

class DefaultCharactersGridRepository: CharactersGridRepository {
    private let networkService: NetworkService

    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func fetchCharacters(from urlString: String) async throws -> RickAndMortyEntity {
        try await networkService.fetchCharacters(from: urlString).toEntity()
    }
}
