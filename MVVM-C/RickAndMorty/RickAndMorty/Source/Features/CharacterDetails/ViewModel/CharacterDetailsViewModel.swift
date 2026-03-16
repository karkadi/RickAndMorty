//
//  CharacterDetailsViewModel.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import Observation
import UIKit
import DIContainer

@MainActor
@Observable
final class CharacterDetailsViewModel {
    @ObservationIgnored
    @Injected private var databaseService: DatabaseServiceProtocol
    @ObservationIgnored
    @Injected private var imageCache: ImageCacheServiceProtocol
    
    var character: Character
    var toggleLike = false
    var image: UIImage?
    
    init(character: Character) {
        self.character = character
    }
    
    func onAppear() async {
        do {
            let updatedCharacter = try await databaseService.markAsSeen(character)
            character = updatedCharacter
            image = await imageCache.image(for: character.image)
        } catch {
            print("Failed to mark as seen: \(error)")
        }
    }
    
    func toggleLike() async {
        do {
            let updatedCharacter = try await databaseService.toggleLike(for: character)
            character = updatedCharacter
            toggleLike.toggle()
        } catch {
            print("Failed to toggle like: \(error)")
        }
    }
}
