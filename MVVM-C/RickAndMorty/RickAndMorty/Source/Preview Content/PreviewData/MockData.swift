//
//  MockData.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Mock
import Foundation
class MockData {
    func fetchCharacters(from _: String) async throws -> APIResponse { Self.mockedCharacters! }
    
    static var mockedCharacters: APIResponse? {
        guard let mockedData = Self.mockedData.data(using: .utf8) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode(APIResponse.self, from: mockedData )
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
