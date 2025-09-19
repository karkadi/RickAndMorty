//
//  CharacterDetailsReducer.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

@Reducer
struct CharacterDetailsReducer {
    // MARK: - Dependencies
    @Dependency(\.databaseClient) private var databaseClient

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var character: ResultModelEntity
    }

    // MARK: - Action
    enum Action {
        case onAppear
        case markAsSeen(ResultModelEntity)
        case toggleLike
        case characterStateLoaded(ResultModelEntity)

        case delegate(Delegate)
        // swiftlint:disable nesting
        enum Delegate: Equatable {
            case updateItem(ResultModelEntity)
        }
        // swiftlint:enable nesting
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let updatedCharacter = try await databaseClient.fetchCharacterState(for: state.character)
                    await send(.markAsSeen(updatedCharacter))
                }

            case .markAsSeen(let updatedCharacter):
                return .run { send in
                    let updatedCharacter = try await databaseClient.markStoryAsSeen(for: updatedCharacter)
                    await send(.characterStateLoaded(updatedCharacter))
                }

            case .toggleLike:
                return .run { [state] send in
                    let updatedCharacter = try await databaseClient.toggleStoryLike(for: state.character)
                    await send(.characterStateLoaded(updatedCharacter))
                }

            case .characterStateLoaded(let character):
                state.character = character
                return .send(.delegate(.updateItem(character)))

            case .delegate:
                return .none
            }
        }
    }
}
