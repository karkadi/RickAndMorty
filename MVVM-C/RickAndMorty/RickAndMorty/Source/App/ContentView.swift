//
//  ContentView.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - View
import SwiftUI
import SwiftData
import MetalKitUI

struct ContentView: View {
    @State private var coordinator = AppCoordinator()
    @State private var gridViewModel = CharactersGridViewModel()
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            CharactersGridView(viewModel: gridViewModel)
                .navigationDestination(for: AppCoordinator.Route.self) { route in
                    switch route {
                    case .main:
                        CharactersGridView(viewModel: gridViewModel)
                    case .details(let character):
                        CharacterDetailsView(character: character)
                    case .about:
                        AboutView(viewModel: .init(aboutInfo: .init()))
                    }
                }
        }
        .onAppear {
            gridViewModel.setup(coordinator: coordinator)
            DatabaseService.shared.setup(modelContext: modelContext)
            ImageCacheService.shared.setup(modelContext: modelContext)
        }
    }
}
