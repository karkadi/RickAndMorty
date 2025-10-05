//
//  CharactersGridClient.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 27/05/2025.
//
import ComposableArchitecture

// MARK: - Protocol
struct CharactersGridClient: Sendable {
    var fetchCharacters: @Sendable () async throws -> RickAndMortyEntity
    var fetchMoreCharacters: @Sendable (_ info: InfoEntity?) async throws -> RickAndMortyEntity
}

// MARK: - Live Implementation
extension CharactersGridClient: DependencyKey {
    static let liveValue: CharactersGridClient = {
        // MARK: - Dependencies
        @Dependency(\.networkClient) var networkClient
        
        return CharactersGridClient(
            fetchCharacters: {
                try await networkClient.fetchCharacters( Constants.firstPage).toEntity()
            },
            
            fetchMoreCharacters: { info in
                try await networkClient.fetchCharacters( info?.next ?? "").toEntity()
            }
        )
    }()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var charactersGridClient: CharactersGridClient {
        get { self[CharactersGridClient.self] }
        set { self[CharactersGridClient.self] = newValue }
    }
}
