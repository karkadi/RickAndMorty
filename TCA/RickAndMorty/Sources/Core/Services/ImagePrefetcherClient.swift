import ComposableArchitecture
import UIKit
import Kingfisher
import Foundation

// MARK: - ImagePrefetcherClient Interface

/// A dependency client for prefetching images
struct ImagePrefetcherClient {
    /// Prefetch images from URLs
    var prefetch: @Sendable (_ urls: [URL]) async throws -> Void
    
    /// Prefetch images with progress tracking
    var prefetchWithProgress: @Sendable (_ urls: [URL], _ progress: @escaping @Sendable (Double) -> Void) async throws -> Void
    
    /// Cancel ongoing prefetch operation
    var cancel: @Sendable () async -> Void
    
    /// Check if currently prefetching
    var isPrefetching: @Sendable () async -> Bool
    
    /// Get cached image for URL
    var cachedImage: @Sendable (URL) async -> UIImage?
    
    /// Clear prefetch cache
    var clearCache: @Sendable () async -> Void
}

// MARK: - Live Implementation

extension ImagePrefetcherClient {
    static let live = {
        let prefetcher = ImagePrefetcherActor()
        
        return Self(
            prefetch: { urls in
                try await prefetcher.prefetch(urls: urls)
            },
            prefetchWithProgress: { urls, progress in
                try await prefetcher.prefetch(urls: urls, progress: progress)
            },
            cancel: {
                await prefetcher.cancel()
            },
            isPrefetching: {
                await prefetcher.isPrefetching
            },
            cachedImage: { url in
                await prefetcher.cachedImage(for: url)
            },
            clearCache: {
                await prefetcher.clearCache()
            }
        )
    }()
}

// MARK: - Actor for Thread Safety

private actor ImagePrefetcherActor {
    private var currentTask: Task<Void, Error>?
    private var progressContinuation: AsyncStream<Double>.Continuation?
    private let screenScale: CGFloat
    
    init() {
        // Safely get screen scale using MainActor
        var scale: CGFloat = 2.0 // Default scale
        if Thread.isMainThread {
            scale = UIScreen.main.scale
        } else {
            // Use DispatchQueue.main.sync carefully - ensure it doesn't deadlock
            scale = DispatchQueue.main.sync {
                UIScreen.main.scale
            }
        }
        self.screenScale = scale
    }
    
    func prefetch(urls: [URL]) async throws {
        // Cancel any existing task
        cancel()
        
        guard !urls.isEmpty else { return }
        
        // Create a new task for prefetching
        let task = Task { [weak self] in
            try await self?.performPrefetch(urls: urls)
            return () // Explicitly return Void
        }
        
        self.currentTask = task
        
        // Wait for the task to complete
        try await task.value
    }
    
    private func performPrefetch(urls: [URL]) async throws {
        // Use Kingfisher's ImagePrefetcher with continuation
        return try await withCheckedThrowingContinuation { continuation in
            let resources = urls.map { KF.ImageResource(downloadURL: $0) }
            
            let prefetcher = ImagePrefetcher(
                resources: resources,
                options: [
                    .scaleFactor(screenScale),
                    .cacheOriginalImage,
                    .backgroundDecode
                ],
                completionHandler: { skipped, failed, completed in
                    if failed.isEmpty {
                        continuation.resume()
                    } else {
                        let error = NSError(
                            domain: "ImagePrefetcher",
                            code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Failed to prefetch \(failed.count) images"]
                        )
                        continuation.resume(throwing: error)
                    }
                }
            )
            
            prefetcher.start()
        }
    }
    
    func prefetch(urls: [URL], progress: @escaping @Sendable (Double) -> Void) async throws {
        // Cancel any existing task
        cancel()
        
        guard !urls.isEmpty else { return }
        
        // Create progress stream
        let (stream, continuation) = AsyncStream<Double>.makeStream()
        self.progressContinuation = continuation
        
        // Start progress monitoring
        let progressTask = Task {
            for await value in stream {
                progress(value)
            }
        }
        
        // Create prefetch task
        let task = Task { [weak self] in
            try await self?.performPrefetchWithProgress(urls: urls)
            return () // Explicitly return Void
        }
        
        self.currentTask = task
        
        do {
            try await task.value
            progressTask.cancel()
            continuation.finish()
        } catch {
            progressTask.cancel()
            continuation.finish()
            throw error
        }
    }
    
    private func performPrefetchWithProgress(urls: [URL]) async throws {
        let total = urls.count
        
        try await withThrowingTaskGroup(of: Int.self) { group in
            for url in urls {
                group.addTask { [weak self] in
                    try await self?.downloadAndCacheImage(url: url)
                    return 1 // Return 1 for each completed image
                }
            }
            
            var completed = 0
            for try await value in group {
                completed += value
                let progress = Double(completed) / Double(total)
                await self.updateProgress(progress)
            }
        }
    }
    
    private func updateProgress(_ progress: Double) async {
        progressContinuation?.yield(progress)
    }
    
    private func downloadAndCacheImage(url: URL) async throws {
        return try await withCheckedThrowingContinuation { continuation in
            KingfisherManager.shared.retrieveImage(with: url) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func cancel() {
        currentTask?.cancel()
        currentTask = nil
        progressContinuation?.finish()
        progressContinuation = nil
    }
    
    var isPrefetching: Bool {
        guard let task = currentTask else { return false }
        return !task.isCancelled
    }
    
    func cachedImage(for url: URL) -> UIImage? {
        let cacheKey = url.absoluteString
        return ImageCache.default.retrieveImageInMemoryCache(forKey: cacheKey)
    }
    
    func clearCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache()
    }
}

// MARK: - AsyncStream Extension

extension AsyncStream {
    static func makeStream() -> (stream: AsyncStream<Element>, continuation: Continuation) {
        var continuation: Continuation!
        let stream = AsyncStream<Element> { cont in
            continuation = cont
        }
        return (stream, continuation)
    }
}

// MARK: - Dependency Registration

extension DependencyValues {
    var imagePrefetcher: ImagePrefetcherClient {
        get { self[ImagePrefetcherKey.self] }
        set { self[ImagePrefetcherKey.self] = newValue }
    }
}

private enum ImagePrefetcherKey: DependencyKey {
    static let liveValue = ImagePrefetcherClient.live
    
    static let testValue = ImagePrefetcherClient(
        prefetch: { _ in },
        prefetchWithProgress: { _, _ in },
        cancel: { },
        isPrefetching: { false },
        cachedImage: { _ in nil },
        clearCache: { }
    )
}
