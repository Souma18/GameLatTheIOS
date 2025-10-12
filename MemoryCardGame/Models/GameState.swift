//
//  GameState.swift
//  MemoryCardGame
//
//  Model cho trạng thái game hiện tại
//

import Foundation

// MARK: - Game State Model
class GameState: ObservableObject {
    @Published var cards: [[Card]] = []
    @Published var flippedCards: [(row: Int, col: Int)] = []
    @Published var matchedPairs: Int = 0
    @Published var moves: Int = 0
    @Published var score: Int = 0
    @Published var timeRemaining: Int = 0
    @Published var isGameCompleted: Bool = false
    @Published var isGamePaused: Bool = false
    @Published var currentLevel: Level?
    
    // Timer cho countdown
    private var gameTimer: Timer?
    
    // MARK: - Initialization
    init() {
        resetGame()
    }
    
    // MARK: - Game Control
    func startGame(with level: Level) {
        self.currentLevel = level
        self.timeRemaining = level.timeLimit ?? 0
        self.isGameCompleted = false
        self.isGamePaused = false
        
        // Tạo cards từ matrix
        createCardsFromMatrix(level.matrix, imageSet: level.imageSet)
        
        // Bắt đầu timer nếu có time limit
        if level.timeLimit != nil {
            startTimer()
        }
    }
    
    func resetGame() {
        cards = []
        flippedCards = []
        matchedPairs = 0
        moves = 0
        score = 0
        timeRemaining = 0
        isGameCompleted = false
        isGamePaused = false
        currentLevel = nil
        stopTimer()
    }
    
    // MARK: - Card Operations
    func flipCard(row: Int, col: Int) {
        // Kiểm tra bounds
        guard row < cards.count && col < cards[row].count else { return }
        
        var card = cards[row][col]
        
        // Không thể lật thẻ đã match hoặc đã lật
        guard !card.isMatched && !card.isFaceUp else { return }
        
        // Nếu đã có 2 thẻ lật, không cho lật thêm
        if flippedCards.count >= 2 {
            return
        }
        
        // Lật thẻ
        card.flipUp()
        cards[row][col] = card
        flippedCards.append((row: row, col: col))
        
        // Nếu đã lật đủ 2 thẻ, kiểm tra match
        if flippedCards.count == 2 {
            moves += 1
            checkForMatch()
        }
    }
    
    private func checkForMatch() {
        guard flippedCards.count == 2 else { return }
        
        let firstCard = cards[flippedCards[0].row][flippedCards[0].col]
        let secondCard = cards[flippedCards[1].row][flippedCards[1].col]
        
        // Delay để người chơi thấy 2 thẻ
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if firstCard.value == secondCard.value {
                // Match thành công
                self.handleMatch()
            } else {
                // Không match, úp thẻ lại
                self.flipCardsBack()
            }
        }
    }
    
    private func handleMatch() {
        // Đánh dấu 2 thẻ đã match
        for (row, col) in flippedCards {
            var card = cards[row][col]
            card.markAsMatched()
            cards[row][col] = card
        }
        
        // Cập nhật score và matched pairs
        matchedPairs += 1
        score += calculateScore()
        
        // Clear flipped cards
        flippedCards = []
        
        // Kiểm tra game completed
        checkGameCompletion()
    }
    
    private func flipCardsBack() {
        // Úp 2 thẻ lại
        for (row, col) in flippedCards {
            var card = cards[row][col]
            card.flipDown()
            cards[row][col] = card
        }
        
        // Clear flipped cards
        flippedCards = []
    }
    
    // MARK: - Game Logic
    private func calculateScore() -> Int {
        // Tính điểm dựa trên số moves và thời gian còn lại
        let baseScore = 100
        let timeBonus = currentLevel?.timeLimit != nil ? timeRemaining * 2 : 0
        let movePenalty = moves > 10 ? (moves - 10) * 5 : 0
        
        return max(baseScore + timeBonus - movePenalty, 10)
    }
    
    private func checkGameCompletion() {
        guard let level = currentLevel else { return }
        
        if matchedPairs >= level.totalPairs {
            isGameCompleted = true
            stopTimer()
        }
    }
    
    // MARK: - Timer Management
    private func startTimer() {
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.gameOver()
            }
        }
    }
    
    private func stopTimer() {
        gameTimer?.invalidate()
        gameTimer = nil
    }
    
    private func gameOver() {
        isGameCompleted = true
        stopTimer()
    }
    
    // MARK: - Helper Methods
    private func createCardsFromMatrix(_ matrix: [[Int]], imageSet: [String]) {
        cards = []
        
        for row in matrix {
            var cardRow: [Card] = []
            for value in row {
                let imageName = getImageName(for: value, imageSet: imageSet)
                let card = Card(value: value, imageName: imageName)
                cardRow.append(card)
            }
            cards.append(cardRow)
        }
    }
    
    private func getImageName(for value: Int, imageSet: [String]) -> String {
        let uniqueValues = Array(Set(cards.flatMap { $0 }.map { $0.value })).sorted()
        guard let index = uniqueValues.firstIndex(of: value) else {
            return imageSet.first ?? "default"
        }
        return imageSet[index]
    }
}
