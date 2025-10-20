//import Foundation
//
//// MARK: - API Models
//struct GameStartResponse {
//    let username: String
//    let level: Int
//    let matrix: [Int]
//    let gridSize: Int
//}
//
//struct LevelUpResponse {
//    let username: String
//    let newLevel: Int
//    let matrix: [Int]
//    let gridSize: Int
//}
//
//// MARK: - Mock API Service
//class MockGameAPI {
//    static let shared = MockGameAPI()
//    
//    // Lưu trữ state của user
//    private var userLevels: [String: Int] = [:]
//    
//    // Định nghĩa các level configs
//    private let levelConfigs: [Int: (gridSize: Int, pairs: Int)] = [
//        1: (gridSize: 2, pairs: 2),    // 2x2 = 4 cards
//        2: (gridSize: 3, pairs: 4),    // Không vuông nhưng 8 cards
//        3: (gridSize: 3, pairs: 6),    // 3x4 = 12 cards
//        4: (gridSize: 4, pairs: 8),    // 4x4 = 16 cards
//        5: (gridSize: 4, pairs: 10),   // 4x5 = 20 cards
//        6: (gridSize: 5, pairs: 12),   // 5x5 = 24 cards (bỏ 1 card)
//    ]
//    
//    private init() {}
//    
//    // Simulate API call với delay
//    private func simulateNetworkDelay() async {
//        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 giây
//    }
//    
//    // API: Start game - Login và nhận level hiện tại
//    func startGame(username: String) async -> GameStartResponse {
//        await simulateNetworkDelay()
//        
//        // Lấy hoặc khởi tạo level cho user
//        let currentLevel = userLevels[username] ?? 1
//        let matrix = generateMatrix(for: currentLevel)
//        let gridSize = getGridSize(for: currentLevel)
//        
//        return GameStartResponse(
//            username: username,
//            level: currentLevel,
//            matrix: matrix,
//            gridSize: gridSize
//        )
//    }
//    
//    // API: Level up - Chuyển sang màn tiếp theo
//    func levelUp(username: String) async -> LevelUpResponse {
//        await simulateNetworkDelay()
//        
//        let currentLevel = userLevels[username] ?? 1
//        let newLevel = min(currentLevel + 1, 6) // Max level 6
//        
//        // Cập nhật level của user
//        userLevels[username] = newLevel
//        
//        let matrix = generateMatrix(for: newLevel)
//        let gridSize = getGridSize(for: newLevel)
//        
//        return LevelUpResponse(
//            username: username,
//            newLevel: newLevel,
//            matrix: matrix,
//            gridSize: gridSize
//        )
//    }
//    
//    // API: Reset progress
//    func resetProgress(username: String) async {
//        await simulateNetworkDelay()
//        userLevels[username] = 1
//    }
//    
//    // MARK: - Helper Methods
//    
//    private func getGridSize(for level: Int) -> Int {
//        return levelConfigs[level]?.gridSize ?? 2
//    }
//    
//    private func generateMatrix(for level: Int) -> [Int] {
//        guard let config = levelConfigs[level] else {
//            return [1, 2, 1, 2] // Default 2x2
//        }
//        
//        let pairs = config.pairs
//        let totalCards = pairs * 2
//        
//        // Tạo các cặp thẻ
//        var matrix: [Int] = []
//        for i in 1...pairs {
//            matrix.append(i)
//            matrix.append(i)
//        }
//        
//        // Shuffle ma trận
//        matrix.shuffle()
//        
//        return matrix
//    }
//}
//
//// MARK: - Fruit Icons Storage
//class FruitIconsStorage {
//    static let shared = FruitIconsStorage()
//    
//    // Danh sách icon trái cây có sẵn trong game
//    let fruitIcons: [Int: String] = [
//        1: "🍓", // Strawberry
//        2: "🍎", // Apple
//        3: "🍌", // Banana
//        4: "🥝", // Kiwi
//        5: "🍇", // Grapes
//        6: "🍊", // Orange
//        7: "🥥", // Coconut
//        8: "🍍", // Pineapple
//        9: "🍉", // Watermelon
//        10: "🍑", // Peach
//        11: "🍒", // Cherry
//        12: "🥭", // Mango
//    ]
//    
//    private init() {}
//    
//    func getIcon(for id: Int) -> String {
//        return fruitIcons[id] ?? "❓"
//    }
//    
//    func getAllIcons() -> [Int: String] {
//        return fruitIcons
//    }
//}
