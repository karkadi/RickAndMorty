//
//  RootReducer.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 19/07/2025.
//

import ComposableArchitecture

// MARK: - App Root Reducer
@Reducer
struct RootReducer {
    @ObservableState
    struct State: Equatable {
        var path = StackState<Path.State>()
        var main = CharactersGridReducer.State()
    }

    enum Action {
        case main(CharactersGridReducer.Action)
        case path(StackAction<Path.State, Path.Action>)
    }

    var body: some Reducer<State, Action> {
        Scope(state: \.main, action: \.main) {
            CharactersGridReducer()
        }
        Reduce { state, action in
            switch action {
            case .main(.navigateToStoryDetails(let character)):
                state.path.append(.storyDetails(CharacterDetailsReducer.State(character: character)))
                return .none

            case .main(.view(.navigateToAbout)):
                state.path.append(.aboutView(AboutReducer.State()))
                return .none

            case .path(.element(id: _, action: .storyDetails(.delegate(.updateItem(let item))))):
                return .send(.main(.updateItem(item)))

            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            Path()
        }
    }

    // MARK: - Path Reducer
    @Reducer
    struct Path {
        // swiftlint:disable nesting
        @ObservableState
        enum State: Equatable {
            case storyDetails(CharacterDetailsReducer.State)
            case aboutView(AboutReducer.State)
        }

        enum Action {
            case storyDetails(CharacterDetailsReducer.Action)
            case aboutView(AboutReducer.Action)
        }
        // swiftlint:enable nesting

        var body: some Reducer<State, Action> {
            Scope(state: \.storyDetails, action: \.storyDetails) {
                CharacterDetailsReducer()
            }
            Scope(state: \.aboutView, action: \.aboutView) {
                AboutReducer()
            }
        }
    }
}
