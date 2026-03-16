//
//  NetworkError.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noData
    case decodingError
}
