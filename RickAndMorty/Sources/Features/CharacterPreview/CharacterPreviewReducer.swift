//
//  CharacterPreviewReducer.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

@Reducer
struct CharacterPreviewReducer {
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
        case characterStateLoaded(ResultModelEntity)
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let character = try await characterDetailsClient.fetchCharacterState(for: state.character)
                    await send(.characterStateLoaded(character))
                }

            case .characterStateLoaded(let character):
                state.character = character
                return .none
            }
        }
    }
}
