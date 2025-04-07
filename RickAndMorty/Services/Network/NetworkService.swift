//
//  RepositoryService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 20/03/2025.
//

import SwiftUI

// sourcery: AutoMockable
protocol NetworkService {
    func fetchCharacters(from urlString: String)async throws -> RickAndMortyDTO
}

// MARK: - Mock

class MockRickAndMortyService: NetworkService {
    func fetchCharacters(from _: String) async throws -> RickAndMortyDTO { Self.mockedCharacters! }

    static var mockedCharacters: RickAndMortyDTO? {
        guard let mockedData = Self.mockedData.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(RickAndMortyDTO.self, from: mockedData )
    }

    static let mockedData = """
        {"info":{"count":826,
        "pages":42,
        "next":"https://rickandmortyapi.com/api/character?page=2",
        "prev":null},
        "results":[
        {"id":20,
        "name":"Ants in my Eyes Johnson",
        "status":"unknown",
        "species":"Human",
        "type":"Human with ants in his eyes",
        "gender":"Male",
        "origin":{"name":"unknown",
        "url":""},
        "location":{"name":"Interdimensional Cable",
        "url":"https://rickandmortyapi.com/api/location/6"},
        "image":"https://rickandmortyapi.com/api/character/avatar/20.jpeg",
        "episode":["https://rickandmortyapi.com/api/episode/8"],
        "url":"https://rickandmortyapi.com/api/character/20",
        "created":"2017-11-04T22:34:53.659Z"}]}
        """
}
