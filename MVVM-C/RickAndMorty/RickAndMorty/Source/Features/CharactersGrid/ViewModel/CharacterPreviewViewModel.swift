//
//  CharacterPreviewViewModel.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import Observation
import DIContainer
import UIKit

@MainActor
@Observable
final class CharacterPreviewViewModel {
    @ObservationIgnored
    @Injected private var databaseService: DatabaseServiceProtocol
    @ObservationIgnored
    @Injected private var imageCache: ImageCacheServiceProtocol
    
    var character: Character
    var image: UIImage?
    
    init(character: Character) {
        self.character = character
    }
    
    func onAppear() async {
        do {
            let updatedCharacter = try await databaseService.fetchCharacterState(character)
            character = updatedCharacter
            image = await imageCache.image(for: character.image)
        } catch {
            print("Failed to fetch character state: \(error)")
        }
    }
}
