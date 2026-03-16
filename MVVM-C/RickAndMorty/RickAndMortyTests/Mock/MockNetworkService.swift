//
//  MockNetworkService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//
import Testing
@testable import RickAndMorty

// MARK: - Mock Network Service for Testing
@MainActor
final class MockNetworkService: NetworkServiceProtocol {
    var shouldSucceed: Bool
    var mockResponse: APIResponse?
    var mockError: Error?
    
    init(shouldSucceed: Bool = true, mockResponse: APIResponse? = nil) {
        self.shouldSucceed = shouldSucceed
        self.mockResponse = mockResponse
    }
    
    func fetchCharacters(page: Int) async throws -> APIResponse {
        if shouldSucceed {
            if let response = mockResponse {
                return response
            }
            return try await createMockResponse()
        } else {
            throw NetworkError.invalidResponse
        }
    }
    
    func fetchMoreCharacters(urlString: String) async throws -> APIResponse {
        if shouldSucceed {
            if let response = mockResponse {
                return response
            }
            return try await createMockResponse()
        } else {
            throw NetworkError.invalidResponse
        }
    }
    
    private func createMockResponse() async throws -> APIResponse {
        let info = Info(count: 1, pages: 1, next: nil, prev: nil)
        let character = CharacterDTO(
            id: 1,
            name: "Mock Character",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://example.com/image.jpg",
            created: "2017-11-04T18:48:46.250Z"
        )
        return APIResponse(info: info, results: [character])
    }
}
