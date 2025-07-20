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
    @Dependency(\.characterDetailsClient) private var characterDetailsClient

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

        enum Delegate: Equatable {
            case updateItem(ResultModelEntity)
        }
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let updatedCharacter = try await characterDetailsClient.fetchCharacterState(for: state.character)
                    await send(.markAsSeen(updatedCharacter))
                }

            case .markAsSeen(let updatedCharacter):
                return .run { send in
                    let updatedCharacter = try await characterDetailsClient.markStoryAsSeen(for: updatedCharacter)
                    await send(.characterStateLoaded(updatedCharacter))
                }

            case .toggleLike:
                return .run { [state] send in
                    let updatedCharacter = try await characterDetailsClient.toggleStoryLike(for: state.character)
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
