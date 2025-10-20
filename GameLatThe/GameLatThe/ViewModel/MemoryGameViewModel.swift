import SwiftUI
import Combine

class MemoryGameViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var currentLevel = 1
    @Published var isGameOver = false
    @Published var gameMessage = "Nhập tên để bắt đầu"
    @Published var score = 0
    @Published var timeElapsed = 0
    @Published var username = ""
    @Published var isLoggedIn = false
    @Published var gridSize = 2
    
    private var firstChosenIndex: Int? = nil
    private var timer: AnyCancellable?
    private var isProcessingMove = false
    private let mockAPI = GameAPI.shared
    private let iconStorage = FruitIconsStorage.shared
    
    init() {
        // Không load level ngay, đợi user login
    }
    
    // Login/Start game
    func startGame(username: String) {
        self.username = username
        Task {
            let response = await mockAPI.startGame(username: username)
            await MainActor.run {
                self.isLoggedIn = true
                self.loadLevelFromResponse(
                    level: response.level,
                    matrix: response.matrix,
                    gridSize: response.gridSize
                )
            }
        }
    }
    
    // Load level từ API response
    private func loadLevelFromResponse(level: Int, matrix: [Int], gridSize: Int) {
        self.cards = matrix.map { Card(contentId: $0) }
        self.gridSize = gridSize
        self.currentLevel = level
        self.isGameOver = false
        self.timeElapsed = 0
        self.startTimer()
        self.gameMessage = "Level \(level) - Bắt đầu!"
    }
    
    // Next level - Gọi API level up
    func nextLevel() {
        Task {
            let response = await mockAPI.levelUp(username: username)
            await MainActor.run {
                self.loadLevelFromResponse(
                    level: response.newLevel,
                    matrix: response.matrix,
                    gridSize: response.gridSize
                )
            }
        }
    }
    
    func startTimer() {
        timer?.cancel()
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in self?.timeElapsed += 1 }
    }
    
    func stopTimer() {
        timer?.cancel()
    }
    
    func choose(_ card: Card) {
        guard !isProcessingMove,
              let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFaceUp,
              !cards[chosenIndex].isMatched else { return }
        
        withAnimation(.easeInOut(duration: 0.4)) {
            cards[chosenIndex].isFaceUp = true
        }
        
        if let firstIndex = firstChosenIndex, firstIndex != chosenIndex {
            isProcessingMove = true
            if cards[firstIndex].contentId == cards[chosenIndex].contentId {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring()) {
                        self.cards[firstIndex].isMatched = true
                        self.cards[chosenIndex].isMatched = true
                    }
                    self.score += 10
                    self.gameMessage = "✨ Ghép cặp đúng!"
                    self.isProcessingMove = false
                    self.checkGameOver()
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.cards[firstIndex].isFaceUp = false
                        self.cards[chosenIndex].isFaceUp = false
                    }
                    self.score -= 2
                    self.gameMessage = "Sai rồi 😅"
                    self.isProcessingMove = false
                }
            }
            firstChosenIndex = nil
        } else {
            firstChosenIndex = chosenIndex
        }
    }
    
    func checkGameOver() {
        if cards.allSatisfy({ $0.isMatched }) {
            stopTimer()
            gameMessage = "🎉 Hoàn thành Level \(currentLevel)! 🎉"
            isGameOver = true
        }
    }
    
    func restartGame() {
        startGame(username: username)
    }
    
    func logout() {
        isLoggedIn = false
        username = ""
        cards = []
        score = 0
        currentLevel = 1
        stopTimer()
    }
    
    func getFruitIcon(for contentId: Int) -> String {
        return iconStorage.getIcon(for: contentId)
    }
}
