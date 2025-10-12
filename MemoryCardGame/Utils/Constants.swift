//
//  Constants.swift
//  MemoryCardGame
//
//  Constants và configuration cho app
//

import SwiftUI
import Foundation

// MARK: - App Constants
struct AppConstants {
    
    // MARK: - App Info
    static let appName = "Memory Card Game"
    static let version = "1.0.0"
    static let buildNumber = "1"
    
    // MARK: - API Configuration
    struct API {
        static let baseURL = "https://api.memorygame.com"
        static let timeout: TimeInterval = 30.0
        static let maxRetries = 3
        
        // Endpoints
        static let levelsEndpoint = "/levels"
        static let gameResultEndpoint = "/game/result"
        static let usersEndpoint = "/users"
        static let leaderboardEndpoint = "/leaderboard"
    }
    
    // MARK: - Game Configuration
    struct Game {
        static let minLevel = 1
        static let maxLevel = 50
        static let defaultTimeLimit = 120 // seconds
        static let maxGridSize = 8 // 8x8 maximum
        static let minGridSize = 2 // 2x2 minimum
        
        // Scoring
        static let baseScore = 100
        static let timeBonusMultiplier = 2
        static let movePenalty = 5
        static let minScore = 10
        
        // Animation
        static let cardFlipDuration: Double = 0.6
        static let cardScaleAnimation: Double = 0.1
        static let levelTransitionDuration: Double = 1.5
    }
    
    // MARK: - UI Configuration
    struct UI {
        // Colors
        static let primaryColor = Color.gamePink
        static let secondaryColor = Color.gamePurple
        static let backgroundColor = Color.gameBackground
        static let cardBackColor = Color.gameLightPink
        
        // Spacing
        static let defaultPadding: CGFloat = 20
        static let cardSpacing: CGFloat = 12
        static let sectionSpacing: CGFloat = 30
        
        // Corner Radius
        static let cardCornerRadius: CGFloat = 12
        static let buttonCornerRadius: CGFloat = 25
        static let textFieldCornerRadius: CGFloat = 25
        
        // Shadow
        static let cardShadowRadius: CGFloat = 4
        static let buttonShadowRadius: CGFloat = 5
        static let shadowOpacity: Double = 0.3
        
        // Animation
        static let defaultAnimationDuration: Double = 0.3
        static let springAnimation = Animation.spring(response: 0.6, dampingFraction: 0.8)
        static let easeInOutAnimation = Animation.easeInOut(duration: 0.3)
        
        // Font Sizes
        static let titleFontSize: CGFloat = 28
        static let headlineFontSize: CGFloat = 20
        static let bodyFontSize: CGFloat = 16
        static let captionFontSize: CGFloat = 12
    }
    
    // MARK: - Image Configuration
    struct Images {
        static let availableImages = [
            "strawberry", "banana", "kiwi", "orange", "grape",
            "apple", "cherry", "lemon", "peach", "pear",
            "watermelon", "pineapple", "mango", "blueberry", "raspberry"
        ]
        
        static let cardBackImageName = "card_back"
        static let defaultImageName = "default"
        
        // Emoji fallbacks
        static let emojiMap: [String: String] = [
            "strawberry": "🍓",
            "banana": "🍌",
            "kiwi": "🥝",
            "orange": "🍊",
            "grape": "🍇",
            "apple": "🍎",
            "cherry": "🍒",
            "lemon": "🍋",
            "peach": "🍑",
            "pear": "🍐",
            "watermelon": "🍉",
            "pineapple": "🍍",
            "mango": "🥭",
            "blueberry": "🫐",
            "raspberry": "🫐"
        ]
    }
    
    // MARK: - User Defaults Keys
    struct UserDefaultsKeys {
        static let currentUser = "currentUser"
        static let bestScore = "bestScore"
        static let totalGamesPlayed = "totalGamesPlayed"
        static let settings = "settings"
        static let lastPlayedLevel = "lastPlayedLevel"
        static let soundEnabled = "soundEnabled"
        static let musicEnabled = "musicEnabled"
        static let hapticFeedbackEnabled = "hapticFeedbackEnabled"
    }
    
    // MARK: - Notification Names
    struct NotificationNames {
        static let gameCompleted = "GameCompleted"
        static let levelCompleted = "LevelCompleted"
        static let newHighScore = "NewHighScore"
        static let userCreated = "UserCreated"
        static let settingsChanged = "SettingsChanged"
    }
    
    // MARK: - Error Messages
    struct ErrorMessages {
        static let networkError = "Network connection error. Please check your internet connection."
        static let apiError = "Server error. Please try again later."
        static let invalidData = "Invalid data received from server."
        static let levelLoadError = "Failed to load level. Please try again."
        static let userCreationError = "Failed to create user. Please try again."
        static let gameSaveError = "Failed to save game progress."
        static let imageLoadError = "Failed to load image."
        static let unknownError = "An unknown error occurred."
    }
    
    // MARK: - Success Messages
    struct SuccessMessages {
        static let levelCompleted = "Level completed successfully!"
        static let userCreated = "Welcome to Memory Card Game!"
        static let gameSaved = "Game progress saved."
        static let highScore = "New high score achieved!"
    }
    
    // MARK: - Development Configuration
    struct Development {
        static let isDebugMode = true
        static let useMockData = true
        static let enableLogging = true
        static let showFPS = false
        static let enableAnalytics = false
    }
}

// MARK: - Game Level Templates
struct LevelTemplates {
    
    /// Template cho level 1 (3x3)
    static let level1 = LevelTemplate(
        rows: 3,
        columns: 3,
        imageCount: 3,
        timeLimit: 120
    )
    
    /// Template cho level 2 (4x4)
    static let level2 = LevelTemplate(
        rows: 4,
        columns: 4,
        imageCount: 4,
        timeLimit: 180
    )
    
    /// Template cho level 3 (5x5)
    static let level3 = LevelTemplate(
        rows: 5,
        columns: 5,
        imageCount: 5,
        timeLimit: 300
    )
    
    /// Template cho level 4 (6x6)
    static let level4 = LevelTemplate(
        rows: 6,
        columns: 6,
        imageCount: 6,
        timeLimit: 420
    )
}

// MARK: - Level Template Struct
struct LevelTemplate {
    let rows: Int
    let columns: Int
    let imageCount: Int
    let timeLimit: Int
    
    var totalCards: Int {
        return rows * columns
    }
    
    var totalPairs: Int {
        return totalCards / 2
    }
    
    var isValid: Bool {
        return totalCards % 2 == 0 && imageCount <= totalPairs
    }
}

// MARK: - App Configuration
struct AppConfig {
    
    /// Get current app configuration
    static var current: AppConfig {
        return AppConfig()
    }
    
    /// Check if running in debug mode
    var isDebug: Bool {
        #if DEBUG
        return true
        #else
        return false
        #endif
    }
    
    /// Check if running on simulator
    var isSimulator: Bool {
        #if targetEnvironment(simulator)
        return true
        #else
        return false
        #endif
    }
    
    /// Get device type
    var deviceType: String {
        #if os(iOS)
        return "iOS"
        #elseif os(macOS)
        return "macOS"
        #else
        return "Unknown"
        #endif
    }
    
    /// Get app version string
    var versionString: String {
        return "\(AppConstants.version) (\(AppConstants.buildNumber))"
    }
}
