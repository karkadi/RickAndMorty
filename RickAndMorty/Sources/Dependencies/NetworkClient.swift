//
//  NetworkClient.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 20/03/2025.
//
import ComposableArchitecture
import Foundation

// MARK: - Protocol
protocol NetworkClientProtocol {
    func fetchCharacters(from urlString: String)async throws -> RickAndMortyDTO
}

// MARK: - Live Implementation
class NetworkClient: NetworkClientProtocol {
    func fetchCharacters(from urlString: String) async throws -> RickAndMortyDTO {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }

        do {
            let decoder = JSONDecoder()
            return try decoder.decode(RickAndMortyDTO.self, from: data)
        } catch {
            throw error
        }
    }
}

// Custom error enum for better error handling
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
}

// MARK: - Dependency Keys
enum NetworkServiceKey: DependencyKey {
    static let liveValue: any NetworkClientProtocol = NetworkClient()
    static let testValue: any NetworkClientProtocol = MockRickAndMortyService()
    static let previewValue: any NetworkClientProtocol = MockRickAndMortyService()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var networkClient: any NetworkClientProtocol {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}

// MARK: - Mock
class MockRickAndMortyService: NetworkClientProtocol {
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
