//
//  MockDatabaseService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import SwiftUI

// MARK: - Mock

class MockDatabaseService: DatabaseService {
    func fetchCharacterState(for characterId: Int) async throws -> CharacterStateDTO? {
        Self.mockedCharacterStates[characterId == 1 ? 0 : 1]
    }

    func updateCharacterState(_: CharacterStateDTO) async throws {
    }

    static var mockedCharacterStates: [CharacterStateDTO] { [
        CharacterStateDTO(id: 1, isSeen: true, isLiked: false),
        CharacterStateDTO(id: 1, isSeen: true, isLiked: false)]}
}
