//
//  SwiftDataService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import Foundation
import SwiftData

class SwiftDataService: @preconcurrency DatabaseService {
    private let container: ModelContainer
    @MainActor private var modelContext: ModelContext {
        container.mainContext
    }

    init() {
        let schema = Schema([ CharacterState.self ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            container = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create SwiftDataService: \(error.localizedDescription)")
        }
    }

    // MARK: - CharacterState
    @MainActor
    func fetchCharacterState(for characterId: Int) -> CharacterState? {
        let predicate = #Predicate<CharacterState> { $0.id == characterId }
        let descriptor = FetchDescriptor<CharacterState>(predicate: predicate)
        return try? modelContext.fetch(descriptor).first
    }
    @MainActor
    func fetchCharacterStates() -> [CharacterState] {
        let descriptor = FetchDescriptor<CharacterState>()
        return (try? modelContext.fetch(descriptor)) ?? []
    }
    @MainActor
    func updateCharacterState(_ state: CharacterState) {
        let characterId = state.id
        let predicate = #Predicate<CharacterState> { $0.id == characterId }
        let descriptor = FetchDescriptor<CharacterState>(predicate: predicate)

        if let existingState = try? modelContext.fetch(descriptor).first {
            // Update existing state
            existingState.isSeen = state.isSeen
            existingState.isLiked = state.isLiked
        } else {
            // Insert new state
            modelContext.insert(state)
        }
        try? modelContext.save()
    }
}
