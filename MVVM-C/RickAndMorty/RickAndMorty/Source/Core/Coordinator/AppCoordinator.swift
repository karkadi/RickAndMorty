//
//  AppCoordinator.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Coordinator (Navigation)
import SwiftUI

@MainActor
@Observable
final class AppCoordinator {
    var path: [Route] = []
    
    enum Route: Hashable {
        case main
        case details(character: Character)
        case about
    }
    
    func navigate(to route: Route) {
        path.append(route)
    }
    
    func navigateBack() {
        path.removeLast()
    }
    
    func navigateToRoot() {
        path.removeAll()
    }
}
