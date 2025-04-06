//
//  DependencyValues+LaunchScreen.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

// MARK: - Dependency Keys
enum LaunchScreenRepositoryKey: DependencyKey {
    static let liveValue: any LaunchScreenRepository = DefaultLaunchScreenRepository()
    static let testValue: any LaunchScreenRepository = DefaultLaunchScreenRepository()
    static let previewValue: any LaunchScreenRepository = DefaultLaunchScreenRepository()
}

enum LaunchScreenUseCaseKey: DependencyKey {
    static let liveValue: LaunchScreenUseCase = DefaultLaunchScreenUseCase()
    static let testValue: LaunchScreenUseCase = DefaultLaunchScreenUseCase()
    static let previewValue: LaunchScreenUseCase = DefaultLaunchScreenUseCase()
}

// MARK: - Dependency Registration
extension DependencyValues {
    var repositoryLaunchScreen: any LaunchScreenRepository {
        get { self[LaunchScreenRepositoryKey.self] }
        set { self[LaunchScreenRepositoryKey.self] = newValue }
    }

    var useCaseLaunchScreen: LaunchScreenUseCase {
        get { self[LaunchScreenUseCaseKey.self] }
        set { self[LaunchScreenUseCaseKey.self] = newValue }
    }
}
