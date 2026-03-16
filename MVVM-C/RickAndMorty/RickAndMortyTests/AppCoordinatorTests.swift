//
//  AppCoordinatorTests.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 07/03/2026.
//
import Testing
@testable import RickAndMorty

// MARK: - Coordinator Tests
@MainActor
struct AppCoordinatorTests {
    
    @Test("AppCoordinator initial state is empty")
    func testInitialState() {
        let coordinator = AppCoordinator()
        
        #expect(coordinator.path.isEmpty)
    }
    
    @Test("AppCoordinator navigates to details screen")
    func testNavigateToDetails() {
        let coordinator = AppCoordinator()
        let character = createMockCharacter()
        
        coordinator.navigate(to: .details(character: character))
        
        #expect(coordinator.path.count == 1)
        
        if case .details(let navCharacter) = coordinator.path.first {
            #expect(navCharacter.id == character.id)
        } else {
            #expect(Bool(false), "Wrong route type")
        }
    }
    
    @Test("AppCoordinator navigates to about screen")
    func testNavigateToAbout() {
        let coordinator = AppCoordinator()
        
        coordinator.navigate(to: .about)
        
        #expect(coordinator.path.count == 1)
        
        if case .about = coordinator.path.first {
            #expect(true)
        } else {
            #expect(Bool(false), "Wrong route type")
        }
    }
    
    @Test("AppCoordinator navigates back")
    func testNavigateBack() {
        let coordinator = AppCoordinator()
        let character = createMockCharacter()
        
        coordinator.navigate(to: .details(character: character))
        coordinator.navigate(to: .about)
        #expect(coordinator.path.count == 2)
        
        coordinator.navigateBack()
        #expect(coordinator.path.count == 1)
        
        if case .details = coordinator.path.first {
            #expect(true)
        } else {
            #expect(Bool(false), "Wrong route type after back navigation")
        }
    }
    
    @Test("AppCoordinator navigates to root")
    func testNavigateToRoot() {
        let coordinator = AppCoordinator()
        let character = createMockCharacter()
        
        coordinator.navigate(to: .details(character: character))
        coordinator.navigate(to: .about)
        #expect(coordinator.path.count == 2)
        
        coordinator.navigateToRoot()
        #expect(coordinator.path.isEmpty)
    }
    
    private func createMockCharacter() -> Character {
        Character(
            id: 1,
            name: "Rick Sanchez",
            status: "Alive",
            species: "Human",
            type: "",
            gender: "Male",
            image: "https://example.com/image.jpg",
            created: "2017-11-04T18:48:46.250Z",
            isSeen: false,
            isLiked: false
        )
    }
}
