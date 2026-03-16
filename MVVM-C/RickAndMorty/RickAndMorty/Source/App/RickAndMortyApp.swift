//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import SwiftUI
import SwiftData

@main
struct RickAndMortyApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
    let container = PersistenceController.shared.container
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .preferredColorScheme(.dark)
        }
        .modelContainer(container)
    }
}
