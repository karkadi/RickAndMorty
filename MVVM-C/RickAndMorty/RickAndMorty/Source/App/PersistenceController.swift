//
//  PersistenceController.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 11/03/2026.
//

import SwiftData
import Foundation

@MainActor
class PersistenceController {
    
    static let shared = PersistenceController()
    
    let container: ModelContainer
    
    init() {
        let schema = Schema([
            LikedCharacter.self,
            CachedImage.self
        ])
        
        let config = ModelConfiguration(schema: schema)
        PersistenceController.prepareDirectory()
        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
    
   static private func prepareDirectory() {
        let url = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first!
        
        try? FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: true
        )
    }
}
