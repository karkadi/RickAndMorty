//
//  CharacterDetailsFeature.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

@Reducer
struct CharacterDetailsFeature {
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
        case markAsSeen(CharacterDetailsEntity)
        case toggleLike
        case characterStateLoaded(CharacterDetailsEntity)
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [state] send in
                    let entiryState = try await characterDetailsClient.fetchCharacterState(for: state.entiryState)
                    await send(.markAsSeen(entiryState))
                }

            case .markAsSeen(let entiryState):
                return .run { send in
                    let updatedState = try await characterDetailsClient.markStoryAsSeen(for: entiryState)
                    await send(.characterStateLoaded(updatedState))
                }

            case .toggleLike:
                return .run { [state] send in
                    let updatedState = try await characterDetailsClient.toggleStoryLike(for: state.entiryState)
                    await send(.characterStateLoaded(updatedState))
                }

            case .characterStateLoaded(let entiryState):
                state.entiryState = entiryState
                return .none
            }
        }
    }
}
