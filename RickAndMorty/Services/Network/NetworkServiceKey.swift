//
//  NetworkServiceKey.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 18/03/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum NetworkServiceKey: DependencyKey {
    static let liveValue: any NetworkService = RickAndMortyService()
    static let testValue: any NetworkService = MockRickAndMortyService()
    static let previewValue: any NetworkService = MockRickAndMortyService()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var networkService: any NetworkService {
        get { self[NetworkServiceKey.self] }
        set { self[NetworkServiceKey.self] = newValue }
    }
}
