//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//

import CachedAsyncImage
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
        // Set image cache limit.
        ImageCache().wrappedValue.setCacheLimit(
            countLimit: 1_000, // 1000 items
            totalCostLimit: 1_024 * 1_024 * 200 // 200 MB
        )
    }
}
