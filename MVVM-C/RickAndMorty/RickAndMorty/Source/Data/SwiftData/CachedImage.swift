//
//  CachedImage.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//
// MARK: - Model
import Foundation
import SwiftData

@Model
final class CachedImage {
    @Attribute(.unique) var url: String
    @Attribute(.externalStorage) var imageData: Data
    var lastAccessed: Date
    
    init(url: String, imageData: Data) {
        self.url = url
        self.imageData = imageData
        self.lastAccessed = Date()
    }
}
