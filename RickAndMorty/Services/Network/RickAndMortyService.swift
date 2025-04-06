//
//  RickAndMortyService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import Foundation

class RickAndMortyService: NetworkService {

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

// Example usage:
func exampleUsage() {

//    Task {
//        do {
//            let rickAndMortyData = try await RickAndMortyService.shared.fetchCharactersAsync()
//            print("Total characters: \(rickAndMortyData.info.count)")
//        } catch {
//            print("Error: \(error.localizedDescription)")
//        }
//    }

}
