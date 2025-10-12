//
//  GameView.swift
//  MemoryCardGame
//
//  View chính cho game screen với grid thẻ bài
//

import SwiftUI

// MARK: - Game View
struct GameView: View {
    
    // MARK: - Properties
    @StateObject private var gameState = GameState()
    @StateObject private var apiService = APIService.shared
    @StateObject private var levelService = LevelService.shared
    
    let user: User
    @State private var currentLevel: Level?
    @State private var isLoading: Bool = true
    @State private var showLevelComplete: Bool = false
    @State private var showGameOver: Bool = false
    @State private var errorMessage: String = ""
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background
            gameBackground
            
            if isLoading {
                // Loading view
                loadingView
            } else if let level = currentLevel {
                // Game content
                gameContent(level: level)
            } else {
                // Error view
                errorView
            }
            
            // Level complete overlay
            if showLevelComplete {
                levelCompleteOverlay
            }
            
            // Game over overlay
            if showGameOver {
                gameOverOverlay
            }
        }
        .onAppear {
            loadLevel()
        }
        .onChange(of: gameState.isGameCompleted) { isCompleted in
            if isCompleted {
                handleGameCompletion()
            }
        }
    }
    
    // MARK: - Background
    private var gameBackground: some View {
        ZStack {
            // Main background
            LinearGradient(
                colors: [.pink.opacity(0.3), .purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Floating fruit decorations
            VStack {
                HStack {
                    Spacer()
                    Text("🍓")
                        .font(.system(size: 30))
                        .opacity(0.3)
                        .offset(x: 20, y: -50)
                }
                Spacer()
                HStack {
                    Text("🍌")
                        .font(.system(size: 25))
                        .opacity(0.3)
                        .offset(x: -30, y: -100)
                    Spacer()
                    Text("🥝")
                        .font(.system(size: 35))
                        .opacity(0.3)
                        .offset(x: 40, y: -80)
                }
                Spacer()
            }
        }
    }
    
    // MARK: - Game Content
    private func gameContent(level: Level) -> some View {
        VStack(spacing: 0) {
            // Header
            gameHeader(level: level)
            
            Spacer()
            
            // Game grid
            gameGrid(level: level)
            
            Spacer()
            
            // Bottom controls
            bottomControls
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Game Header
    private func gameHeader(level: Level) -> some View {
        HStack {
            // Level info
            VStack(alignment: .leading, spacing: 4) {
                Text("LEVEL \(level.levelNumber)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .shadow(color: .white, radius: 1)
            }
            
            Spacer()
            
            // Player info
            HStack(spacing: 8) {
                Text("\(user.username)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.pink)
                    .shadow(color: .white, radius: 1)
                
                Circle()
                    .fill(Color.pink.opacity(0.3))
                    .frame(width: 30, height: 30)
                    .overlay(
                        Text(String(user.username.prefix(1)).uppercased())
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.pink)
                    )
            }
        }
        .padding(.top, 10)
    }
    
    // MARK: - Game Grid
    private func gameGrid(level: Level) -> some View {
        LazyVGrid(
            columns: createGridColumns(count: level.columns),
            spacing: 12
        ) {
            ForEach(0..<level.rows, id: \.self) { row in
                ForEach(0..<level.columns, id: \.self) { col in
                    if row < gameState.cards.count && col < gameState.cards[row].count {
                        CardView(card: gameState.cards[row][col])
                            .frame(width: cardSize, height: cardSize)
                            .onTapGesture {
                                gameState.flipCard(row: row, col: col)
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Bottom Controls
    private var bottomControls: some View {
        HStack {
            // Score info
            VStack(alignment: .leading, spacing: 4) {
                Text("Score: \(gameState.score)")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text("Moves: \(gameState.moves)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Replay button
            Button(action: replayLevel) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("REPLAY")
                }
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [.pink, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(25)
                .shadow(color: .pink.opacity(0.3), radius: 5, x: 0, y: 3)
            }
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 30)
    }
    
    // MARK: - Loading View
    private var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .pink))
                .scaleEffect(1.5)
            
            Text("Loading Level...")
                .font(.headline)
                .foregroundColor(.primary)
        }
    }
    
    // MARK: - Error View
    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 50))
                .foregroundColor(.orange)
            
            Text("Error Loading Game")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            Text(errorMessage)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Button("Retry") {
                loadLevel()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding(.horizontal, 40)
    }
    
    // MARK: - Level Complete Overlay
    private var levelCompleteOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("🎉")
                    .font(.system(size: 80))
                
                Text("Level Complete!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Score: \(gameState.score)")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Text("Moves: \(gameState.moves)")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.8))
                
                Button("Next Level") {
                    loadNextLevel()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Game Over Overlay
    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("⏰")
                    .font(.system(size: 80))
                
                Text("Time's Up!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Text("Final Score: \(gameState.score)")
                    .font(.title2)
                    .foregroundColor(.white.opacity(0.8))
                
                Button("Try Again") {
                    replayLevel()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .padding(.horizontal, 40)
        }
    }
    
    // MARK: - Computed Properties
    
    private var cardSize: CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 60 // Total horizontal padding
        let spacing: CGFloat = 12 * 2 // Grid spacing
        let availableWidth = screenWidth - padding - spacing
        
        guard let level = currentLevel else { return 80 }
        return availableWidth / CGFloat(level.columns)
    }
    
    private func createGridColumns(count: Int) -> [GridItem] {
        return Array(repeating: GridItem(.flexible(), spacing: 12), count: count)
    }
    
    // MARK: - Private Methods
    
    private func loadLevel() {
        isLoading = true
        
        apiService.requestLevel(levelNumber: user.currentLevel, username: user.username)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    isLoading = false
                    
                    switch completion {
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                    case .finished:
                        break
                    }
                },
                receiveValue: { response in
                    if response.success {
                        currentLevel = levelService.createLevelFromAPI(response)
                        if let level = currentLevel {
                            gameState.startGame(with: level)
                        }
                    } else {
                        errorMessage = response.message ?? "Failed to load level"
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    private func loadNextLevel() {
        showLevelComplete = false
        // Update user level and load next
        loadLevel()
    }
    
    private func replayLevel() {
        showLevelComplete = false
        showGameOver = false
        if let level = currentLevel {
            gameState.startGame(with: level)
        }
    }
    
    private func handleGameCompletion() {
        // Submit result to server
        apiService.submitGameResult(
            username: user.username,
            levelNumber: user.currentLevel,
            score: gameState.score,
            moves: gameState.moves
        )
        .receive(on: DispatchQueue.main)
        .sink(
            receiveCompletion: { _ in },
            receiveValue: { response in
                if response.success {
                    showLevelComplete = true
                }
            }
        )
        .store(in: &cancellables)
    }
    
    @State private var cancellables = Set<AnyCancellable>()
}

// MARK: - Primary Button Style
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(
                LinearGradient(
                    colors: [.pink, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
            .shadow(color: .pink.opacity(0.3), radius: 5, x: 0, y: 3)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

// MARK: - Preview
struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(user: User(username: "Player123"))
    }
}
