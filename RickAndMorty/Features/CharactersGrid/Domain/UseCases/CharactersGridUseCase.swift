//
//  CharactersGridUseCase.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//
import ComposableArchitecture

protocol CharactersGridUseCase {
    func fetchCharacters() async throws -> RickAndMortyEntity
    func fetchMoreCharacters(from info: InfoEntity?) async throws -> RickAndMortyEntity
}

class DefaultCharactersGridUseCase: CharactersGridUseCase {
    @Dependency(\.repositoryCharactersGrid) private var repository

    private let firstPage = "https://rickandmortyapi.com/api/character?page=1"

    func fetchCharacters() async throws -> RickAndMortyEntity {
        try await repository.fetchCharacters(from: firstPage)
    }

    func fetchMoreCharacters(from info: InfoEntity?) async throws -> RickAndMortyEntity {
        try await repository.fetchCharacters(from: info?.next ?? "")
    }
}
