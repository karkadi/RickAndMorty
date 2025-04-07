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
    @Dependency(\.useCaseCharacterDetails) private var useCase

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        let character: ResultModelEntity
        var characterState: CharacterDetailsEntity?
    }

    // MARK: - Action
    enum Action {
        case onAppear
        case markAsSeen(CharacterDetailsEntity?)
        case toggleLike
        case characterStateLoaded(CharacterDetailsEntity?)
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { [characterId = state.character.id] send in
                    let characterState = await useCase.fetchCharacterState(for: characterId)
                    await send(.markAsSeen(characterState))
                }

            case .markAsSeen(let story):
                return .run { [characterId = state.character.id] send in
                    await useCase.markStoryAsSeen(
                        characterId: characterId,
                        currentStory: story
                    )
                    let updatedStory = await useCase.fetchCharacterState(for: characterId)
                    await send(.characterStateLoaded(updatedStory))
                }

            case .toggleLike:
                return .run { [characterId = state.character.id, currentStory = state.characterState] send in
                    await useCase.toggleStoryLike(
                        characterId: characterId,
                        currentStory: currentStory
                    )
                    let updatedStory = await useCase.fetchCharacterState(for: characterId)
                    await send(.characterStateLoaded(updatedStory))
                }

            case .characterStateLoaded(let characterState):
                state.characterState = characterState
                return .none
            }
        }
    }
}
