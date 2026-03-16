//
//  CharactersGridViewModel.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - ViewModel

import SwiftUI
import SwiftData
import DIContainer

@MainActor
@Observable
final class CharactersGridViewModel {
    @ObservationIgnored
    @Injected private var networkService: NetworkServiceProtocol
    @ObservationIgnored
    @Injected private var databaseService: DatabaseServiceProtocol
    @ObservationIgnored
    @Injected private var imageCache: ImageCacheServiceProtocol
    
    var characters: [Character] = []
    var isLoading = false
    var isLoadingMore = false
    var error: String?
    var currentPage = 1
    var hasNextPage = true
    var nextPageURL: String?
    
    // Track the last failed operation to retry
    private var lastFailedOperation: RetryableOperation?
    
    private var coordinator: AppCoordinator?
    
    enum RetryableOperation {
        case initialLoad
        case loadMore(nextURL: String)
        case refresh
    }
    
    func setup(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    func loadCharacters() async {
        guard !isLoading else { return }
        
        isLoading = true
        error = nil
        
        do {
            let response = try await networkService.fetchCharacters(page: 1)
            
            var loadedCharacters: [Character] = []
            for dto in response.results {
                let character = dto.toCharacter()
                let statefulCharacter = try await databaseService.fetchCharacterState(character)
                loadedCharacters.append(statefulCharacter)
            }
            
            characters = loadedCharacters
            currentPage = 1
            hasNextPage = response.info.next != nil
            nextPageURL = response.info.next
            
            // Clear any failed operation on success
            lastFailedOperation = nil
            
            // Prefetch images
            let imageUrls = characters.map { $0.image }
            Task {
                await imageCache.prefetchImages(urls: imageUrls)
            }
            
        } catch {
            self.error = error.localizedDescription
            self.lastFailedOperation = .initialLoad
        }
        
        isLoading = false
    }
    
    func loadMoreCharacters() async {
        guard !isLoadingMore, let nextURL = nextPageURL else { return }
        
        isLoadingMore = true
        error = nil
        
        do {
            let response = try await networkService.fetchMoreCharacters(urlString: nextURL)
            
            var newCharacters: [Character] = []
            for dto in response.results {
                let character = dto.toCharacter()
                let statefulCharacter = try await databaseService.fetchCharacterState(character)
                newCharacters.append(statefulCharacter)
            }
            
            characters.append(contentsOf: newCharacters)
            hasNextPage = response.info.next != nil
            nextPageURL = response.info.next
            
            // Clear any failed operation on success
            lastFailedOperation = nil
            
            // Prefetch images for new characters
            let imageUrls = newCharacters.map { $0.image }
            Task {
                await imageCache.prefetchImages(urls: imageUrls)
            }
            
        } catch {
            self.error = error.localizedDescription
            if let nextURL = nextPageURL {
                self.lastFailedOperation = .loadMore(nextURL: nextURL)
            }
        }
        
        isLoadingMore = false
    }
    
    func refresh() async {
        characters.removeAll()
        currentPage = 1
        hasNextPage = true
        nextPageURL = nil
        error = nil
        await loadCharacters()
    }
    
    func retryLastFailedOperation() async {
        guard let operation = lastFailedOperation else { return }
        
        switch operation {
        case .initialLoad:
            await loadCharacters()
        case .loadMore(let nextURL):
            // Temporarily set the nextPageURL to the failed one
            let originalNextURL = nextPageURL
            nextPageURL = nextURL
            await loadMoreCharacters()
            // Restore if still failed, or keep the new one if succeeded
            if error != nil {
                nextPageURL = originalNextURL
            }
        case .refresh:
            await refresh()
        }
    }
    
    func navigateToDetails(character: Character) {
        coordinator?.navigate(to: .details(character: character))
    }
    
    func navigateToAbout() {
        coordinator?.navigate(to: .about)
    }
    
    func clearError() {
        error = nil
        lastFailedOperation = nil
    }
}
