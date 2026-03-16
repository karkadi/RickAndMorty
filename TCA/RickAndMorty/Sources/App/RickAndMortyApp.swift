//
//  RickAndMortyApp.swift
//  RickAndMorty
//
//  Created by Arkadiy KAZAZYAN on 06/04/2025.
//
import DebugSwift
import Kingfisher
import SQLiteData
import SwiftUI

@main
struct RickAndMortyApp: App {
    @UIApplicationDelegateAdaptor private var appDelegate: AppDelegate
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
            print("Failed to prepare dependencies: \(error)")
        }
        // Set Kingfisher cache limits
        let cache = ImageCache.default
        cache.memoryStorage.config.countLimit = 1_000
        cache.memoryStorage.config.totalCostLimit = 1_024 * 1_024 * 200 // 200 MB
        cache.diskStorage.config.sizeLimit = 1_024 * 1_024 * 500 // 500 MB on disk
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private let debugSwift = DebugSwift()
    
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        // Remove comment below to remove specific features and comment DebugSwift.setup() not to double trigger.
        // DebugSwift.setup(hideFeatures: [.interface, .app, .resources, .performance])
        
        // If you have New Relic, disable leak detector to prevent conflicts:
        // debugSwift.setup(disable: [.leaksDetector])
#if DEBUG
        print("Hey, DebugSwift is running! 🎉")
        
        debugSwift
            .setup(enableBetaFeatures: [.swiftUIRenderTracking])
            .show()
        
        // To fix Alamofire `uploadProgress`
        //        DebugSwift.Network.delegate = self
        
        // MARK: Custom Actions Demo - Including Network History Clear
        setupCustomActions()
        
        // Request push notification permissions for APNS token demo
        requestPushNotificationPermissions()
#endif
        return true
    }
    
    // MARK: - Deep Link Handling
    /*
     func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
     // Handle debugswift:// URLs
     if url.scheme == "debugswift" {
     handleDeepLink(url)
     return true
     }
     return false
     }
     
     func handleDeepLinkFromSwiftUI(_ url: URL) {
     handleDeepLink(url)
     }
     
     private func handleDeepLink(_ url: URL) {
     // Show test view with deep link details
     DispatchQueue.main.async {
     guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
     return
     }
     
     // Find the main app window (not CustomWindow from DebugSwift)
     let appWindow = windowScene.windows.first { window in
     let isCustomWindow = String(describing: type(of: window)).contains("CustomWindow")
     return !isCustomWindow && window.rootViewController != nil
     }
     
     guard let window = appWindow else {
     return
     }
     
     // Get the topmost view controller
     guard let topViewController = self.getTopViewController(from: window.rootViewController) else {
     return
     }
     
     let testView = DeepLinkTestView(url: url)
     let hostingController = UIHostingController(rootView: testView)
     hostingController.modalPresentationStyle = .fullScreen
     
     topViewController.present(hostingController, animated: true)
     }
     }
     */
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
    
    // MARK: - Push Notification Setup
    
    private func requestPushNotificationPermissions() {
        Task { @MainActor in
            let center = UNUserNotificationCenter.current()
            
            // Inform DebugSwift that we're about to request permissions
            DebugSwift.APNSToken.willRequestPermissions()
            
            do {
                let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
                if granted {
                    // Register for remote notifications
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    // Inform DebugSwift that permissions were denied
                    DebugSwift.APNSToken.didDenyPermissions()
                }
            } catch {
                print("Failed to request notification permissions: \(error)")
                DebugSwift.APNSToken.didFailToRegister(error: error)
            }
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

// MARK: - Alamofire bugfix in uploadProgress

extension AppDelegate: @preconcurrency CustomHTTPProtocolDelegate {
    func urlSession(
        _ protocol: URLProtocol,
        _ session: URLSession,
        task: URLSessionTask,
        didSendBodyData bytesSent: Int64,
        totalBytesSent: Int64,
        totalBytesExpectedToSend: Int64
    ) {
        // This is a workaround to fix the uploadProgress bug in Alamofire
        // It will be removed in the future when Alamofire is fixed
        // Please check the Alamofire issue for more details:
        //        Session.default.session.getAllTasks { tasks in
        //            let uploadTask = tasks.first(where: { $0.taskIdentifier == task.taskIdentifier }) ?? task
        //            Session.default.rootQueue.async {
        //                Session.default.delegate.urlSession(
        //                    session,
        //                    task: uploadTask,
        //                    didSendBodyData: bytesSent,
        //                    totalBytesSent: totalBytesSent,
        //                    totalBytesExpectedToSend: totalBytesExpectedToSend
        //                )
        //            }
        //        }
    }
}
