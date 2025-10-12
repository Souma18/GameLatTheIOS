//
//  MemoryCardGameApp.swift
//  MemoryCardGame
//
//  Main App file cho Memory Card Game
//

import SwiftUI

// MARK: - Main App
@main
struct MemoryCardGameApp: App {
    
    // MARK: - App Delegate (optional)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    // MARK: - Body
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // Force light mode for consistent design
                .onAppear {
                    setupApp()
                }
        }
    }
    
    // MARK: - Private Methods
    
    /// Setup app configuration
    private func setupApp() {
        // Configure app appearance
        configureAppearance()
        
        // Initialize services
        initializeServices()
        
        // Setup notifications (if needed)
        setupNotifications()
    }
    
    /// Configure app appearance
    private func configureAppearance() {
        // Navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        // Tab bar appearance
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()
        tabAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
    }
    
    /// Initialize app services
    private func initializeServices() {
        // Preload images
        ImageManager.shared.preloadImages(ImageManager.shared.getAllAvailableImages())
        
        // Setup API service
        let _ = APIService.shared
        
        // Setup level service
        let _ = LevelService.shared
        
        print("🎮 Memory Card Game initialized successfully!")
    }
    
    /// Setup notifications
    private func setupNotifications() {
        // Request notification permission if needed
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("✅ Notification permission granted")
            } else if let error = error {
                print("❌ Notification permission denied: \(error.localizedDescription)")
            }
        }
    }
}

// MARK: - App Delegate
class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // Configure app launch
        print("🚀 Memory Card Game launched")
        
        // Setup analytics or crash reporting here if needed
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // App will become inactive
        print("⏸️ App will resign active")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // App entered background
        print("📱 App entered background")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // App will enter foreground
        print("🔄 App will enter foreground")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // App became active
        print("▶️ App became active")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // App will terminate
        print("🛑 App will terminate")
    }
}

// MARK: - App Extensions
extension MemoryCardGameApp {
    
    /// Get app version
    static var version: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    /// Get build number
    static var buildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    /// Get app name
    static var appName: String {
        return Bundle.main.infoDictionary?["CFBundleName"] as? String ?? "Memory Card Game"
    }
}

// MARK: - Debug Extensions
#if DEBUG
extension MemoryCardGameApp {
    
    /// Print app info for debugging
    func printAppInfo() {
        print("📱 App: \(MemoryCardGameApp.appName)")
        print("📋 Version: \(MemoryCardGameApp.version)")
        print("🔢 Build: \(MemoryCardGameApp.buildNumber)")
        print("🖥️ Platform: iOS")
        print("📱 Device: \(UIDevice.current.model)")
        print("💾 OS Version: \(UIDevice.current.systemVersion)")
    }
}
#endif
