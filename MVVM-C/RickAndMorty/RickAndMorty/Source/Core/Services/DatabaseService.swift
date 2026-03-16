//
//  DatabaseService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Database Service
import SwiftData
import Foundation

// MARK: - Protocol Definition
protocol DatabaseServiceProtocol: Sendable {
    func fetchCharacterState(_ character: Character) async throws -> Character
    func toggleLike(for character: Character) async throws -> Character
    func markAsSeen(_ character: Character) async throws -> Character
}

@MainActor
@Observable
final class DatabaseService: DatabaseServiceProtocol {
    static let shared = DatabaseService()
    private var modelContext: ModelContext?
    
    private init() {}
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetchCharacterState(_ character: Character) async throws -> Character {
        guard let modelContext = modelContext else { return character }
        
        // Use a simple FetchDescriptor with a predicate string
        let id = character.id
        let descriptor = FetchDescriptor<LikedCharacter>(
            predicate: #Predicate { $0.id == id }
        )
        
        let likedCharacters = try modelContext.fetch(descriptor)
        
        if let liked = likedCharacters.first {
            return Character(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: character.image,
                created: character.created,
                isSeen: liked.isSeen || character.isSeen,
                isLiked: liked.isLiked
            )
        }
        
        return character
    }
    
    func toggleLike(for character: Character) async throws -> Character {
        guard let modelContext = modelContext else { return character }
        
        let id = character.id
        let descriptor = FetchDescriptor<LikedCharacter>(
            predicate: #Predicate { $0.id == id }
        )
        
        let likedCharacters = try modelContext.fetch(descriptor)
        
        if let liked = likedCharacters.first {
            liked.isLiked.toggle()
            try modelContext.save()
            
            return Character(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: character.image,
                created: character.created,
                isSeen: liked.isSeen,
                isLiked: liked.isLiked
            )
        } else {
            let newLiked = LikedCharacter(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: character.image,
                created: character.created,
                isLiked: true,
                isSeen: character.isSeen
            )
            modelContext.insert(newLiked)
            try modelContext.save()
            
            return Character(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: character.image,
                created: character.created,
                isSeen: character.isSeen,
                isLiked: true
            )
        }
    }
    
    func markAsSeen(_ character: Character) async throws -> Character {
        guard let modelContext = modelContext else { return character }
        
        let id = character.id
        let descriptor = FetchDescriptor<LikedCharacter>(
            predicate: #Predicate { $0.id == id }
        )
        
        let likedCharacters = try modelContext.fetch(descriptor)
        
        if let liked = likedCharacters.first {
            liked.isSeen = true
            try modelContext.save()
            
            return Character(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: character.image,
                created: character.created,
                isSeen: true,
                isLiked: liked.isLiked
            )
        } else {
            let newLiked = LikedCharacter(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: character.image,
                created: character.created,
                isLiked: false,
                isSeen: true
            )
            modelContext.insert(newLiked)
            try modelContext.save()
            
            return Character(
                id: character.id,
                name: character.name,
                status: character.status,
                species: character.species,
                type: character.type,
                gender: character.gender,
                image: character.image,
                created: character.created,
                isSeen: true,
                isLiked: false
            )
        }
    }
    
    func fetchAllLikedCharacters() async throws -> [LikedCharacter] {
        guard let modelContext = modelContext else { return [] }
        
        let descriptor = FetchDescriptor<LikedCharacter>(
            sortBy: [SortDescriptor(\.name)]
        )
        
        return try modelContext.fetch(descriptor)
    }
}
