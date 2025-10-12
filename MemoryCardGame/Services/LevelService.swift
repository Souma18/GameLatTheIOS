//
//  LevelService.swift
//  MemoryCardGame
//
//  Service xử lý logic level và ma trận game
//

import Foundation

// MARK: - Level Service Protocol
protocol LevelServiceProtocol {
    func generateLevel(levelNumber: Int) -> Level?
    func validateMatrix(_ matrix: [[Int]]) -> Bool
    func createCardsFromMatrix(_ matrix: [[Int]], imageSet: [String]) -> [[Card]]
}

// MARK: - Level Service Implementation
class LevelService: LevelServiceProtocol, ObservableObject {
    
    // MARK: - Singleton
    static let shared = LevelService()
    
    private init() {}
    
    // MARK: - Level Generation
    func generateLevel(levelNumber: Int) -> Level? {
        // Tạo level dựa trên số level
        switch levelNumber {
        case 1:
            return createLevel1()
        case 2:
            return createLevel2()
        case 3:
            return createLevel3()
        default:
            return createRandomLevel(levelNumber)
        }
    }
    
    // MARK: - Specific Level Creation
    private func createLevel1() -> Level {
        let matrix = [[1,2,3],[1,2,3],[1,2,3]]
        let imageSet = ["strawberry", "banana", "kiwi"]
        
        return Level(
            id: 1,
            levelNumber: 1,
            matrix: matrix,
            imageSet: imageSet,
            timeLimit: 120 // 2 phút
        )
    }
    
    private func createLevel2() -> Level {
        let matrix = [
            [1,2,3,4],
            [1,2,3,4],
            [1,2,3,4],
            [1,2,3,4]
        ]
        let imageSet = ["strawberry", "banana", "kiwi", "orange"]
        
        return Level(
            id: 2,
            levelNumber: 2,
            matrix: matrix,
            imageSet: imageSet,
            timeLimit: 180 // 3 phút
        )
    }
    
    private func createLevel3() -> Level {
        let matrix = [
            [1,2,3,4,5],
            [1,2,3,4,5],
            [1,2,3,4,5],
            [1,2,3,4,5],
            [1,2,3,4,5]
        ]
        let imageSet = ["strawberry", "banana", "kiwi", "orange", "grape"]
        
        return Level(
            id: 3,
            levelNumber: 3,
            matrix: matrix,
            imageSet: imageSet,
            timeLimit: 300 // 5 phút
        )
    }
    
    // MARK: - Random Level Generation
    private func createRandomLevel(_ levelNumber: Int) -> Level {
        // Tạo size grid dựa trên level
        let size = min(3 + (levelNumber - 1) / 2, 6) // Max 6x6
        let totalCards = size * size
        let uniquePairs = totalCards / 2
        
        // Tạo ma trận với các cặp ngẫu nhiên
        var values: [Int] = []
        for i in 1...uniquePairs {
            values.append(i)
            values.append(i)
        }
        values.shuffle()
        
        // Chuyển thành ma trận 2D
        var matrix: [[Int]] = []
        for row in 0..<size {
            var rowValues: [Int] = []
            for col in 0..<size {
                let index = row * size + col
                rowValues.append(values[index])
            }
            matrix.append(rowValues)
        }
        
        // Tạo image set
        let imageSet = generateImageSet(for: uniquePairs)
        
        return Level(
            id: levelNumber,
            levelNumber: levelNumber,
            matrix: matrix,
            imageSet: imageSet,
            timeLimit: calculateTimeLimit(for: levelNumber)
        )
    }
    
    // MARK: - Helper Methods
    func validateMatrix(_ matrix: [[Int]]) -> Bool {
        // Kiểm tra ma trận không rỗng
        guard !matrix.isEmpty && !matrix[0].isEmpty else { return false }
        
        // Kiểm tra tất cả hàng có cùng số cột
        let firstRowColumns = matrix[0].count
        for row in matrix {
            if row.count != firstRowColumns {
                return false
            }
        }
        
        // Kiểm tra số thẻ phải chẵn
        let totalCards = matrix.count * matrix[0].count
        guard totalCards % 2 == 0 else { return false }
        
        // Kiểm tra có đủ cặp
        let uniqueValues = Set(matrix.flatMap { $0 })
        let expectedPairs = totalCards / 2
        
        // Đếm số lần xuất hiện của mỗi giá trị
        var valueCounts: [Int: Int] = [:]
        for row in matrix {
            for value in row {
                valueCounts[value, default: 0] += 1
            }
        }
        
        // Kiểm tra mỗi giá trị xuất hiện đúng 2 lần
        for (_, count) in valueCounts {
            if count != 2 {
                return false
            }
        }
        
        return true
    }
    
    func createCardsFromMatrix(_ matrix: [[Int]], imageSet: [String]) -> [[Card]] {
        var cards: [[Card]] = []
        
        for row in matrix {
            var cardRow: [Card] = []
            for value in row {
                let imageName = getImageName(for: value, imageSet: imageSet)
                let card = Card(value: value, imageName: imageName)
                cardRow.append(card)
            }
            cards.append(cardRow)
        }
        
        return cards
    }
    
    // MARK: - Private Helper Methods
    private func generateImageSet(for count: Int) -> [String] {
        let availableImages = [
            "strawberry", "banana", "kiwi", "orange", "grape",
            "apple", "cherry", "lemon", "peach", "pear",
            "watermelon", "pineapple", "mango", "blueberry", "raspberry"
        ]
        
        return Array(availableImages.prefix(count))
    }
    
    private func calculateTimeLimit(for level: Int) -> Int {
        // Tính time limit dựa trên độ khó level
        let baseTime = 60 // 1 phút cơ bản
        let additionalTime = level * 30 // Thêm 30 giây mỗi level
        return baseTime + additionalTime
    }
    
    private func getImageName(for value: Int, imageSet: [String]) -> String {
        // Lấy tên ảnh tương ứng với giá trị
        let uniqueValues = Array(Set([value])).sorted()
        guard let index = uniqueValues.firstIndex(of: value),
              index < imageSet.count else {
            return imageSet.first ?? "default"
        }
        return imageSet[index]
    }
}

// MARK: - Level Service Extensions
extension LevelService {
    // Tạo level từ API response
    func createLevelFromAPI(_ response: LevelAPIResponse) -> Level? {
        guard validateMatrix(response.matrix) else {
            print("❌ Invalid matrix from API")
            return nil
        }
        
        return Level.fromAPIResponse(response)
    }
    
    // Tạo level test cho development
    func createTestLevel() -> Level {
        return createLevel1()
    }
}
