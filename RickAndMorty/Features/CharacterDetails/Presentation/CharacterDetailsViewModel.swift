//
//  CharacterDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

@Reducer
struct CharacterDetailsViewModel {
    // MARK: - Dependencies
    @Dependency(\.useCaseCharacterDetails) private var useCase

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
                    let entiryState = try await useCase.fetchCharacterState(for: state.entiryState)
                    await send(.markAsSeen(entiryState))
                }

            case .markAsSeen(let entiryState):
                return .run { send in
                    let updatedState = try await useCase.markStoryAsSeen(for: entiryState)
                    await send(.characterStateLoaded(updatedState))
                }

            case .toggleLike:
                return .run { [state] send in
                    let updatedState = try await useCase.toggleStoryLike(for: state.entiryState)
                    await send(.characterStateLoaded(updatedState))
                }

            case .characterStateLoaded(let entiryState):
                state.entiryState = entiryState
                return .none
            }
        }
    }
}
