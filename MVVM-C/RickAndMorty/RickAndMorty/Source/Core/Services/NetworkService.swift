//
//  NetworkService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Network Service
import Foundation

// MARK: - Protocol Definition
protocol NetworkServiceProtocol: Sendable {
    func fetchCharacters(page: Int) async throws -> APIResponse
    func fetchMoreCharacters(urlString: String) async throws -> APIResponse
}

// Make NetworkService non-isolated or use a dedicated actor for network calls
final class NetworkService: Sendable, NetworkServiceProtocol {
    static let shared = NetworkService()
    private let baseURL = "https://rickandmortyapi.com/api"
    private let session = URLSession.shared
    
    private init() {}
    
    func fetchCharacters(page: Int = 1) async throws -> APIResponse {
        let urlString = "\(baseURL)/character?page=\(page)"
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            // Use a dedicated decoder with a custom decoding strategy if needed
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(APIResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
    
    func fetchMoreCharacters(urlString: String) async throws -> APIResponse {
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await session.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(APIResponse.self, from: data)
        } catch {
            throw NetworkError.decodingError
        }
    }
}
