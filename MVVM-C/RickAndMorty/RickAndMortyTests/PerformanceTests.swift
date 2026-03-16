//
//  PerformanceTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//

import Testing
import Foundation
@testable import RickAndMorty

// MARK: - Performance Helper
struct PerformanceMetric {
    let time: Duration
    let iterations: Int
    let averageTime: Duration
}

// MARK: - Performance Tests
@MainActor
struct PerformanceTests {
    
    @Test("JSON decoding performance with custom metric")
    func testJSONDecodingPerformance() async throws {
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
                    "image": "https://rickandmortyapi.com/api/character/avatar/1.jpeg",
                    "created": "2017-11-04T18:48:46.250Z"
                }
            ]
        }
        """.data(using: .utf8)!
        
        let metrics = try await measurePerformance(iterations: 50) {
            let decoder = JSONDecoder()
            _ = try decoder.decode(APIResponse.self, from: json)
        }
        
        #expect(metrics.averageTime < .milliseconds(5))
        print("Average decoding time: \(metrics.averageTime)")
    }
    
    @Test("Image URL string processing performance")
    func testImageURLProcessingPerformance() async throws {
        let urls = (1...1000).map {
            "https://rickandmortyapi.com/api/character/avatar/\($0).jpeg"
        }
        
        let metrics = await measurePerformance(iterations: 10) {
            _ = urls.compactMap { URL(string: $0) }
        }
        
        #expect(metrics.averageTime < .milliseconds(50))
    }
    
    @Test("Character filtering performance")
    func testCharacterFilteringPerformance() async throws {
        let characters = createMockCharacters(count: 1000)
        
        let metrics = await measurePerformance(iterations: 10) {
            _ = characters.filter { $0.status == "Alive" }
            _ = characters.filter { $0.species == "Human" }
            _ = characters.sorted { $0.name < $1.name }
        }
        
        #expect(metrics.averageTime < .milliseconds(100))
    }
    
    // Helper method to measure performance
    private func measurePerformance(
        iterations: Int = 10,
        warmingIterations: Int = 3,
        operation: () throws -> Void
    ) async rethrows -> PerformanceMetric {
        var totalDuration: Duration = .zero
        
        // Warming up
        for _ in 0..<warmingIterations {
            try operation()
        }
        
        // Actual measurements
        for _ in 0..<iterations {
            let start = ContinuousClock.now
            try operation()
            let end = ContinuousClock.now
            totalDuration += (end - start)
        }
        
        let averageTime = totalDuration / iterations
        
        return PerformanceMetric(
            time: totalDuration,
            iterations: iterations,
            averageTime: averageTime
        )
    }
    
    // Helper to create mock characters for performance testing
    private func createMockCharacters(count: Int) -> [Character] {
        var characters: [Character] = []
        let statuses = ["Alive", "Dead", "Unknown"]
        let species = ["Human", "Alien", "Robot", "Animal"]
        let genders = ["Male", "Female", "Unknown"]
        
        for i in 1...count {
            let character = Character(
                id: i,
                name: "Character \(i)",
                status: statuses.randomElement() ?? "Alive",
                species: species.randomElement() ?? "Human",
                type: i % 3 == 0 ? "Type \(i)" : "",
                gender: genders.randomElement() ?? "Male",
                image: "https://example.com/\(i).jpg",
                created: "2024-01-01T00:00:00.000Z",
                isSeen: Bool.random(),
                isLiked: Bool.random()
            )
            characters.append(character)
        }
        return characters
    }
}
