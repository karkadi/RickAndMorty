//
//  CharactersGridFeature.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

@Reducer
struct CharactersGridFeature {
    // MARK: - Dependencies
    @Dependency(\.charactersGridClient) private var charactersGridClient

    @Reducer(state: .equatable)
    enum Path {
        case storyDetails(CharacterDetailsFeature)
    }

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var info: InfoEntity?
        var characters: [ResultModelEntity] = []
        var isLoadingMore = false
        var error: Error?
        var path = StackState<Path.State>()

        static func == (lhs: CharactersGridFeature.State, rhs: CharactersGridFeature.State) -> Bool {
            lhs.characters == rhs.characters
            && lhs.isLoadingMore == rhs.isLoadingMore
            && (lhs.error == nil) == (rhs.error == nil)
        }
    }

    // MARK: - Action
    enum Action: ViewAction {
        case view(View)
        case path(StackActionOf<Path>)

        case storiesLoaded(Result<RickAndMortyEntity, Error>)
        case moreStoriesLoaded(Result<RickAndMortyEntity, Error>)

        enum View {
             case onAppear
             case refresh
             case loadMore
         }
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .view(.onAppear):
                return .run { send in
                    await send(.view(.refresh))
                }

            case .view(.refresh):
                return .run { send in
                    do {
                        let rickAndMortyData = try await charactersGridClient.fetchCharacters()
                        await send(.storiesLoaded(.success(rickAndMortyData)))
                    } catch {
                        await send(.storiesLoaded(.failure(error)))
                    }
                }

            case .view(.loadMore):
                guard !state.isLoadingMore, state.info?.next != nil else { return .none }
                state.isLoadingMore = true
                return .run { [info = state.info] send in
                    do {
                        let rickAndMortyData = try await charactersGridClient.fetchMoreCharacters(from: info)
                        await send(.moreStoriesLoaded(.success(rickAndMortyData)))
                    } catch {
                        await send(.moreStoriesLoaded(.failure(error)))
                    }
                }

            case .path:
                return .none

            case .moreStoriesLoaded(.success(let data)):
                state.characters.append(contentsOf: data.results)
                state.info = data.info
                state.error = nil
                state.isLoadingMore = false
                return .none

            case .moreStoriesLoaded(.failure(let error)):
                state.characters = []
                state.error = error
                state.isLoadingMore = false
                return .none

            case .storiesLoaded(.success(let data)):
                state.characters = data.results
                state.info = data.info
                state.error = nil
                return .none

            case .storiesLoaded(.failure(let error)):
                state.characters = []
                state.error = error
                return .none
            }
        }
        .forEach(\.path, action: \.path)
        ._printChanges()
    }
}
