//
//  CharacterPreviewFeature.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

@Reducer
struct CharacterPreviewFeature {
    // MARK: - Dependencies
    @Dependency(\.characterDetailsClient) private var characterDetailsClient

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        let character: ResultModelEntity
        var entiryState: CharacterDetailsEntity
    }

    // MARK: - Action
    enum Action {
        case onAppear
        case characterStateLoaded(CharacterDetailsEntity)
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let entiryState = try await characterDetailsClient.fetchCharacterState(for: state.entiryState)
                    await send(.characterStateLoaded(entiryState))
                }

            case .characterStateLoaded(let entry):
                state.entiryState = entry
                return .none
            }
        }
    }
}
