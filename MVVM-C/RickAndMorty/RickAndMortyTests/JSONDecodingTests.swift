//
//  JSONDecodingTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//

import Testing
import Foundation
@testable import RickAndMorty

// MARK: - JSON Decoding Tests
@MainActor
struct JSONDecodingTests {
    
    @Test("APIResponse decodes correctly from JSON")
    func testAPIResponseDecoding() throws {
        let json = """
        {
            "info": {
                "count": 826,
                "pages": 42,
                "next": "https://rickandmortyapi.com/api/character?page=2",
                "prev": null
            },
            "results": [
                {
                    "id": 1,
                    "name": "Rick Sanchez",
                    "status": "Alive",
                    "species": "Human",
                    "type": "",
                    "gender": "Male",
                    "origin": {
                        "name": "Earth",
                        "url": "https://rickandmortyapi.com/api/location/1"
                    },
                    "location": {
                        "name": "Earth",
                        "url": "https://rickandmortyapi.com/api/location/20"
                    },
                    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    "episode": [
                        "https://rickandmortyapi.com/api/episode/1"
                    ],
                    "url": "https://rickandmortyapi.com/api/character/1",
                    "created": "2017-11-04T18:48:46.250Z"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        let response = try decoder.decode(APIResponse.self, from: json)
        
        #expect(response.info.count == 826)
        #expect(response.info.pages == 42)
        #expect(response.info.next == "https://rickandmortyapi.com/api/character?page=2")
        #expect(response.results.count == 1)
        #expect(response.results[0].id == 1)
        #expect(response.results[0].name == "Rick Sanchez")
        #expect(response.results[0].status == "Alive")
    }
}

