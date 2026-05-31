//
//  CharactersGridViewModelTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//
import Testing
import DIContainer
@testable import RickAndMorty

// MARK: - ViewModel Tests
@MainActor
final class CharactersGridViewModelTests {
    
    let mockService = MockNetworkService()

    @MainActor
    init() async throws {
        DependencyOverrideStore.shared.override(\.databaseService, with: MockDatabaseService())
        DependencyOverrideStore.shared.override(\.imageCacheService, with: MockImageCacheService())
        DependencyOverrideStore.shared.override(\.networkService, with: mockService)
    }
    
    deinit {
        Task { @MainActor in DependencyOverrideStore.shared.reset() }
    }
        
    @Test("CharactersGridViewModel initial state is correct")
    func testInitialState() {
        let viewModel = CharactersGridViewModel()
        
        #expect(viewModel.characters.isEmpty)
        #expect(viewModel.isLoading == false)
        #expect(viewModel.isLoadingMore == false)
        #expect(viewModel.error == nil)
        #expect(viewModel.currentPage == 1)
        #expect(viewModel.hasNextPage == true)
    }
    
    @Test("CharactersGridViewModel loads characters successfully")
    func testLoadCharactersSuccess() async {
              
        mockService.shouldSucceed = true
        
        let viewModel = CharactersGridViewModel()

        await viewModel.loadCharacters()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.characters.count > 0)
        #expect(viewModel.error == nil)
    }
    
    @Test("CharactersGridViewModel handles error gracefully")
    func testLoadCharactersFailure() async {
        mockService.shouldSucceed = false
        
        let viewModel = CharactersGridViewModel()
        
        await viewModel.loadCharacters()
        
        #expect(viewModel.isLoading == false)
        #expect(viewModel.error != nil)
    }
    
    @Test("CharactersGridViewModel loads more characters")
    func testLoadMoreCharacters() async {
        let viewModel = CharactersGridViewModel()
        
        // First load initial characters
        await viewModel.loadCharacters()
        let initialCount = viewModel.characters.count
        
        // Then load more
        await viewModel.loadMoreCharacters()
        
        #expect(viewModel.characters.count >= initialCount)
        #expect(viewModel.isLoadingMore == false)
    }
}

