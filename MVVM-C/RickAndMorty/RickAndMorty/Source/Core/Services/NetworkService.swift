//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Network Service
import Foundation
import DIContainer

// MARK: - Protocol Definition
protocol NetworkServiceProtocol: Sendable {
    func fetchCharacters(page: Int) async throws -> APIResponse
    func fetchMoreCharacters(urlString: String) async throws -> APIResponse
}

// MARK: - Network Service
final class NetworkService: Sendable, NetworkServiceProtocol {
    static let shared = NetworkService()
    private let session = URLSession.shared
    
    private init() {}
    
    private func performRequest<T: Decodable>(_ request: URLRequest) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            throw NetworkError.decodingError
        }
    }
    
    func fetchCharacters(page: Int = 1) async throws -> APIResponse {
        let request = APIEndpoint.characters(page: page).urlRequest
        return try await performRequest(request)
    }
    
    func fetchMoreCharacters(urlString: String) async throws -> APIResponse {
        let request = APIEndpoint.nextPage(urlString: urlString).urlRequest
        return try await performRequest(request)
    }
}

enum NetworkServiceKey: DependencyKey {
    static let liveValue: NetworkServiceProtocol = NetworkService.shared
}

extension DependencyValues {
    var networkService: NetworkServiceProtocol {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}
