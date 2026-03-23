//
//  ImageCacheService.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

// MARK: - Image Cache Service
import SwiftUI
import SwiftData

protocol ImageCacheServiceProtocol: Sendable {
    func image(for url: String) async -> UIImage?
    func prefetchImages(urls: [String]) async
}

@MainActor
@Observable
final class ImageCacheService: ImageCacheServiceProtocol {
    static let shared = ImageCacheService()
    private var modelContext: ModelContext?
    private let memoryCache = NSCache<NSString, UIImage>()
    
    private init() {
        memoryCache.countLimit = 100
        memoryCache.totalCostLimit = 50 * 1024 * 1024 // 50 MB
    }
    
    func setup(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func image(for url: String) async -> UIImage? {
        // Check memory cache first
        let cacheKey = NSString(string: url)
        if let cachedImage = memoryCache.object(forKey: cacheKey) {
            return cachedImage
        }
        
        // Check disk cache (SwiftData)
        if let cachedImage = await loadFromDisk(url: url) {
            memoryCache.setObject(cachedImage, forKey: cacheKey)
            return cachedImage
        }
        
        // Download from network
        guard let imageURL = URL(string: url) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: imageURL)
            if let image = UIImage(data: data) {
                // Cache in memory
                memoryCache.setObject(image, forKey: cacheKey)
                
                // Cache to disk
                await saveToDisk(url: url, imageData: data)
                
                return image
            }
        } catch {
            print("Failed to download image: \(error)")
        }
        
        return nil
    }
    
    private func loadFromDisk(url: String) async -> UIImage? {
        guard let modelContext = modelContext else { return nil }
        
        let descriptor = FetchDescriptor<CachedImage>(
            predicate: #Predicate { $0.url == url }
        )
        
        do {
            if let cached = try modelContext.fetch(descriptor).first {
                cached.lastAccessed = Date()
                try modelContext.save()
                return UIImage(data: cached.imageData)
            }
        } catch {
            print("Failed to load from disk: \(error)")
        }
        
        return nil
    }
    
    private func saveToDisk(url: String, imageData: Data) async {
        guard let modelContext = modelContext else { return }
        
        let cachedImage = CachedImage(url: url, imageData: imageData)
        modelContext.insert(cachedImage)
        
        // Clean up old cache if needed
        await cleanUpOldCache()
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save to disk: \(error)")
        }
    }
    
    private func cleanUpOldCache() async {
        guard let modelContext = modelContext else { return }
        
        let sevenDaysAgo = Date().addingTimeInterval(-7 * 24 * 60 * 60)
        
        let descriptor = FetchDescriptor<CachedImage>(
            predicate: #Predicate { $0.lastAccessed < sevenDaysAgo }
        )
        
        do {
            let oldImages = try modelContext.fetch(descriptor)
            for image in oldImages {
                modelContext.delete(image)
            }
            try modelContext.save()
        } catch {
            print("Failed to clean up cache: \(error)")
        }
    }
    
    func prefetchImages(urls: [String]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls.prefix(20) {
                group.addTask { [weak self] in
                    // Since we're in a @MainActor class, this closure is already on MainActor
                    _ = await self?.image(for: url)
                }
            }
        }
    }
    
    func clearMemoryCache() {
        memoryCache.removeAllObjects()
    }
}
