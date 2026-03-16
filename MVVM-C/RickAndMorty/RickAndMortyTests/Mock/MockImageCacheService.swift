//
//  MockImageCacheService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 09/03/2026.
//

import Testing
import Foundation
import UIKit
@testable import RickAndMorty

// MARK: - Mock Image Cache Service
@MainActor
final class MockImageCacheService: ImageCacheServiceProtocol {
    var imageForURLCallCount = 0
    var prefetchImagesCallCount = 0
    
    func image(for url: String) async -> UIImage? {
        imageForURLCallCount += 1
        return UIImage(named: "Rick_et_Morty_Logo_FR")
    }
    
    func prefetchImages(urls: [String]) async {
        prefetchImagesCallCount += 1
    }
}
