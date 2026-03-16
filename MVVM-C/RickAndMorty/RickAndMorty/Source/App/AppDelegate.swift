//
//  AppDelegate.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/03/2026.
//

import DebugSwift
import UIKit
import DIContainer

class AppDelegate: NSObject, UIApplicationDelegate {
    private let debugSwift = DebugSwift()
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        registerSevices()
        
        // Remove comment below to remove specific features and comment DebugSwift.setup() not to double trigger.
        // DebugSwift.setup(hideFeatures: [.interface, .app, .resources, .performance])
        
        // If you have New Relic, disable leak detector to prevent conflicts:
        // debugSwift.setup(disable: [.leaksDetector])
#if DEBUG
        print("Hey, DebugSwift is running! 🎉")
        
        debugSwift
            .setup(enableBetaFeatures: [.swiftUIRenderTracking])
            .show()
        
        // MARK: Custom Actions Demo - Including Network History Clear
        setupCustomActions()
        
#endif
        return true
    }
    
    // Register Services
    private func registerSevices() {
        DIContainer.shared.register(DatabaseServiceProtocol.self) { DatabaseService.shared }
        DIContainer.shared.register(NetworkServiceProtocol.self) { NetworkService.shared }
        DIContainer.shared.register(ImageCacheServiceProtocol.self) { ImageCacheService.shared }
    }
    
    private func getTopViewController(from viewController: UIViewController?) -> UIViewController? {
        if let presented = viewController?.presentedViewController {
            return getTopViewController(from: presented)
        }
        
        if let navigation = viewController as? UINavigationController {
            return getTopViewController(from: navigation.visibleViewController)
        }
        
        if let tab = viewController as? UITabBarController {
            return getTopViewController(from: tab.selectedViewController)
        }
        
        return viewController
    }
    
    func additionalViewControllers() -> [UIViewController] {
        let viewController = UITableViewController()
        viewController.title = "PURE"
        return [viewController]
    }
    
    // MARK: - Custom Actions Setup
    
    private func setupCustomActions() {
        DebugSwift.App.shared.customAction = {
            [
                .init(title: "Environment Management", actions: [
                    .init(title: "Clear Network History") {
                        DebugSwift.Network.shared.clearNetworkHistory()
                        print("✅ Network history cleared!")
                    },
                    .init(title: "Clear All Network Data") {
                        DebugSwift.Network.shared.clearAllNetworkData()
                        print("✅ All network data cleared!")
                    },
                    .init(title: "Switch to Development") {
                        // Your environment switch logic here
                        print("🔄 Switching to Development...")
                        DebugSwift.Network.shared.clearNetworkHistory()
                        print("✅ Switched to Development & cleared network history")
                    },
                    .init(title: "Switch to Production") {
                        // Your environment switch logic here
                        print("🔄 Switching to Production...")
                        DebugSwift.Network.shared.clearNetworkHistory()
                        print("✅ Switched to Production & cleared network history")
                    }
                ]),
                .init(title: "Development Tools", actions: [
                    .init(title: "Clear UserDefaults") {
                        // Example: Clear specific user data
                        print("🗑️ UserDefaults cleared")
                    },
                    .init(title: "Reset App State") {
                        print("🔄 App state reset")
                    }
                ])
            ]
        }
    }
    
}

// MARK: - Push Notification Delegate Methods

extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // Register the device token with DebugSwift for debugging
        DebugSwift.APNSToken.didRegister(deviceToken: deviceToken)
        
        // Your existing push notification setup code would go here
        // For example, sending the token to your server
        let tokenString = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("📱 Registered for push notifications with token: \(tokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // Register the failure with DebugSwift for debugging
        DebugSwift.APNSToken.didFailToRegister(error: error)
        
        // Your existing error handling code would go here
        print("❌ Failed to register for push notifications: \(error.localizedDescription)")
    }
}
