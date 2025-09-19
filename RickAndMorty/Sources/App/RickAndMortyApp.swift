//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import CachedAsyncImage
import SQLiteData
import SwiftUI

@main
struct RickAndMortyApp: App {
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .preferredColorScheme(.dark)
        }
    }

    init() {
        do {
            try prepareDependencies {
                try $0.bootstrapDatabase()
            }
        } catch {
            // You could log this to a logging framework, crashlytics, etc.
            print("Failed to prepare dependencies: \(error)")
            // Optionally handle the error more gracefully, e.g., by showing a UI alert
        }
        // Set image cache limit.
        ImageCache().wrappedValue.setCacheLimit(
            countLimit: 1_000, // 1000 items
            totalCostLimit: 1_024 * 1_024 * 200 // 200 MB
        )
    }
}
