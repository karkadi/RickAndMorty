//
//  DatabaseService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 14/03/2025.
//

import SwiftUI

// sourcery: AutoMockable
protocol DatabaseService {
    func fetchCharacterState(for characterId: Int) -> CharacterState?
    func fetchCharacterStates() -> [CharacterState]
    func updateCharacterState(_ state: CharacterState)
 }

// MARK: - Mock

class MockDatabaseService: DatabaseService {
    func fetchCharacterState(for characterId: Int) -> CharacterState? {
        Self.mockedCharacterStates[characterId == 1 ? 0 : 1]
    }
    func fetchCharacterStates() -> [CharacterState] { Self.mockedCharacterStates }
    func updateCharacterState(_: CharacterState) { }

    static var mockedCharacterStates: [CharacterState] { [CharacterState(id: 1), CharacterState(id: 1, isSeen: true)]}
}
