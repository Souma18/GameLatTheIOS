//
//  ContentView.swift
//  MemoryCardGame
//
//  Main content view quản lý navigation giữa các screens
//

import SwiftUI

// MARK: - App State
enum AppState {
    case userInput
    case game(user: User)
    case loading
}

// MARK: - Content View
struct ContentView: View {
    
    // MARK: - Properties
    @State private var appState: AppState = .userInput
    @State private var currentUser: User?
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Main content based on app state
            switch appState {
            case .userInput:
                UserInputView { user in
                    handleUserCreated(user)
                }
                
            case .game(let user):
                GameView(user: user)
                
            case .loading:
                loadingView
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appState)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        ZStack {
            // Background
            LinearGradient(
                colors: [.pink.opacity(0.3), .purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Logo
                Text("🧠")
                    .font(.system(size: 100))
                    .scaleEffect(1.0)
                    .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: true)
                
                // Loading text
                Text("Memory Card Game")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Text("Preparing your game...")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // Loading indicator
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                    .scaleEffect(1.2)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Xử lý khi user được tạo thành công
    private func handleUserCreated(_ user: User) {
        currentUser = user
        
        // Show loading state briefly
        appState = .loading
        
        // Transition to game after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            appState = .game(user: user)
        }
    }
    
    /// Reset về màn hình nhập tên
    private func resetToUserInput() {
        currentUser = nil
        appState = .userInput
    }
}

// MARK: - Content View Extensions
extension ContentView {
    
    /// Navigate to specific game state
    func navigateToGame(user: User) {
        currentUser = user
        appState = .game(user: user)
    }
    
    /// Navigate back to user input
    func navigateToUserInput() {
        resetToUserInput()
    }
}

// MARK: - Preview
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // User Input Preview
            ContentView()
                .previewDisplayName("User Input")
            
            // Game Preview
            ContentView()
                .onAppear {
                    // Simulate game state for preview
                }
                .previewDisplayName("Game View")
        }
    }
}
