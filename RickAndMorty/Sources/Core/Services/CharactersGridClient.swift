//
//  CharactersGridClient.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 27/05/2025.
//
import ComposableArchitecture

// MARK: - Protocol
protocol CharactersGridClientProtocol {
    func fetchCharacters() async throws -> RickAndMortyEntity
    func fetchMoreCharacters(from info: InfoEntity?) async throws -> RickAndMortyEntity
}

// MARK: - Live Implementation
final class CharactersGridClient: CharactersGridClientProtocol {
    // MARK: - Dependencies
    @Dependency(\.networkClient) private var networkClient

    func fetchCharacters() async throws -> RickAndMortyEntity {
        try await networkClient.fetchCharacters(from: Constants.firstPage).toEntity()
    }

    func fetchMoreCharacters(from info: InfoEntity?) async throws -> RickAndMortyEntity {
        try await networkClient.fetchCharacters(from: info?.next ?? "").toEntity()
    }
}

// MARK: - Dependency Keys
enum CharactersGridClientKey: DependencyKey {
    static let liveValue: any CharactersGridClientProtocol = CharactersGridClient()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var charactersGridClient: CharactersGridClientProtocol {
        get { self[CharactersGridClientKey.self] }
        set { self[CharactersGridClientKey.self] = newValue }
    }
}
