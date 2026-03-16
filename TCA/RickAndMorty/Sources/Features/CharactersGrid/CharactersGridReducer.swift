//
//  CharactersGridReducer.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import ComposableArchitecture
import Foundation
import UIKit

@Reducer
struct CharactersGridReducer {
    // MARK: - Dependencies
    @Dependency(\.charactersGridClient) private var charactersGridClient
    @Dependency(\.imagePrefetcher) private var imagePrefetcher
    
    private enum CancelID { case prefetch }
    
    @Reducer
    enum Path {
        case storyDetails(CharacterDetailsReducer)
    }
    
    // MARK: - State
    @ObservableState
    struct State: Equatable {
        var info: InfoEntity?
        var characters: [ResultModelEntity] = []
        var isLoadingMore = false
        var isCharactersLoaded = false
        var error: Error?
        var prefetchProgress: Double = 0
        var isPrefetching = false
        
        static func == (lhs: CharactersGridReducer.State, rhs: CharactersGridReducer.State) -> Bool {
            lhs.characters == rhs.characters
            && lhs.isLoadingMore == rhs.isLoadingMore
            && (lhs.error == nil) == (rhs.error == nil)
        }
    }
    
    // MARK: - Action
    enum Action: ViewAction {
        case navigateToStoryDetails(ResultModelEntity)
        
        case updateItem(ResultModelEntity)
        
        case storiesLoaded(Result<RickAndMortyEntity, Error>)
        case moreStoriesLoaded(Result<RickAndMortyEntity, Error>)
        case prefetchImages([URL])
        case prefetchProgressUpdated(Double)
        case prefetchCompleted(TaskResult<Void>)
        case imageRetrieved(URL, UIImage?)
        
        case view(View)
        // swiftlint:disable nesting
        enum View {
            case onAppear
            case refresh
            case loadMore
            case navigateToAbout
        }
        // swiftlint:enable nesting
    }
    
    // MARK: - Reducer
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .updateItem(let item):
                if let index = state.characters.firstIndex(where: { $0.id == item.id }) {
                    state.characters[index] = item
                }
                return .none
                
            case .navigateToStoryDetails, .view(.navigateToAbout):
                return .none // Navigation handled by parent
                
            case .view(.onAppear):
                if state.isCharactersLoaded { return .none }
                return .send(.view(.refresh))
                
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
                        let rickAndMortyData = try await charactersGridClient.fetchMoreCharacters(info)
                        await send(.moreStoriesLoaded(.success(rickAndMortyData)))
                    } catch {
                        await send(.moreStoriesLoaded(.failure(error)))
                    }
                }
                
            case .prefetchImages(let urls):
                return .run { _ in
                    // Create a stream for progress updates
                    let progressStream = AsyncStream<Double> { continuation in
                        Task {
                            do {
                                try await imagePrefetcher.prefetchWithProgress(urls) { progress in
                                    continuation.yield(progress)
                                }
                                continuation.finish()
                            } catch {
                                continuation.finish()
                            }
                        }
                    }
                    /*
                    // Observe progress
                    for await progress in progressStream {
                        await send(.prefetchProgressUpdated(progress))
                    }
                    
                    // Check final result
                    do {
                        try await imagePrefetcher.prefetch(urls)
                        await send(.prefetchCompleted(.success(())))
                    } catch {
                        await send(.prefetchCompleted(.failure(error)))
                    }
                     */
                }
                .cancellable(id: CancelID.prefetch)
                
            case let .prefetchProgressUpdated(progress):
                state.prefetchProgress = progress
                return .none
                
            case .prefetchCompleted(.success):
                state.isPrefetching = false
                state.prefetchProgress = 1.0
                
                // Retrieve cached images after prefetch
                return .run { [characters = state.characters] send in
                    for character in characters {
                        if let url = URL(string: character.image),
                            let image = await imagePrefetcher.cachedImage(url) {
                            await send(.imageRetrieved(url, image))
                        }
                    }
                }
                
            case let .prefetchCompleted(.failure(error)):
                state.isPrefetching = false
                state.error = error
                return .none
                
            case let .imageRetrieved(url, image):
           //     state.prefetchedImages[url] = image
                return .none
                
            case .moreStoriesLoaded(.success(let data)):
                state.characters.append(contentsOf: data.results)
                state.info = data.info
                state.error = nil
                state.isLoadingMore = false
                state.isCharactersLoaded = true
                let urls = data.results.compactMap { URL(string: $0.image) }
                return .send(.prefetchImages(urls))
                
            case .moreStoriesLoaded(.failure(let error)):
                state.characters = []
                state.error = error
                state.isLoadingMore = false
                return .none
                
            case .storiesLoaded(.success(let data)):
                state.characters = data.results
                state.info = data.info
                state.error = nil
                let urls = data.results.compactMap { URL(string: $0.image) }
                return .send(.prefetchImages(urls))
                
            case .storiesLoaded(.failure(let error)):
                state.characters = []
                state.error = error
                return .none
            }
        }
        //  ._printChanges()
    }
}
