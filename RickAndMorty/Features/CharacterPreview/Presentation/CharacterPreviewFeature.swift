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
    @Dependency(\.useCaseCharacterPreview) private var useCase

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        let user: ResultModelEntity
        var isSeen: Bool = false
        var isLiked: Bool = false
    }
    
    // MARK: - Action
    enum Action {
        case onAppear
        case characterStateLoaded(CharacterPreviewEntity?)
    }
    
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [characterId = state.user.id] send in
                    let characterState = await useCase.fetchCharacterState(for: characterId)
                    await send(.characterStateLoaded(characterState))
                }
                
            case .characterStateLoaded(let characterState):
                state.isSeen = characterState?.isSeen ?? false
                state.isLiked = characterState?.isLiked ?? false
                return .none
            }
        }
    }
}
