//
//  CharactersGridViewModel.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture

@Reducer
struct CharactersGridViewModel {
    // MARK: - Dependencies
    @Dependency(\.useCaseCharactersGrid) private var useCase

    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var info: InfoEntity?
        var characters: [ResultModelEntity] = []
        var isLoadingMore = false
        var error: Error?

        static func == (lhs: CharactersGridViewModel.State, rhs: CharactersGridViewModel.State) -> Bool {
            lhs.characters == rhs.characters
            && lhs.isLoadingMore == rhs.isLoadingMore
            && (lhs.error == nil) == (rhs.error == nil)
        }
    }

    // MARK: - Action
    enum Action {
        case onAppear
        case refresh
        case loadMore
        case storiesLoaded(Result<RickAndMortyEntity, Error>)
        case moreStoriesLoaded(Result<RickAndMortyEntity, Error>)
    }

    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
                    await send(.refresh)
                }

            case .refresh:
                return .run { send in
                    do {
                        let rickAndMortyData = try await useCase.fetchCharacters()
                        await send(.storiesLoaded(.success(rickAndMortyData)))
                    } catch {
                        await send(.storiesLoaded(.failure(error)))
                    }
                }

            case .loadMore:
                guard !state.isLoadingMore, state.info?.next != nil else { return .none }
                state.isLoadingMore = true
                return .run { [info = state.info] send in
                    do {
                        let rickAndMortyData = try await useCase.fetchMoreCharacters(from: info)
                        await send(.moreStoriesLoaded(.success(rickAndMortyData)))
                    } catch {
                        await send(.moreStoriesLoaded(.failure(error)))
                    }
                }

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
    }
}
