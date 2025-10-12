//
//  Level.swift
//  MemoryCardGame
//
//  Model cho level và ma trận game
//

import Foundation

// MARK: - Level Model
struct Level: Codable, Identifiable {
    let id: Int
    let levelNumber: Int
    let matrix: [[Int]]        // Ma trận 2D chứa giá trị thẻ
    let imageSet: [String]     // Danh sách tên ảnh cho level này
    let rows: Int              // Số hàng
    let columns: Int           // Số cột
    let totalPairs: Int        // Tổng số cặp thẻ
    let timeLimit: Int?        // Giới hạn thời gian (giây)
    
    init(id: Int, levelNumber: Int, matrix: [[Int]], imageSet: [String], timeLimit: Int? = nil) {
        self.id = id
        self.levelNumber = levelNumber
        self.matrix = matrix
        self.imageSet = imageSet
        self.rows = matrix.count
        self.columns = matrix.first?.count ?? 0
        self.timeLimit = timeLimit
        
        // Tính tổng số cặp thẻ
        let totalCards = rows * columns
        self.totalPairs = totalCards / 2
    }
}

// MARK: - Level Extensions
extension Level {
    // Kiểm tra ma trận có hợp lệ không
    var isValid: Bool {
        // Kiểm tra ma trận không rỗng
        guard !matrix.isEmpty && !matrix[0].isEmpty else { return false }
        
        // Kiểm tra tất cả hàng có cùng số cột
        let firstRowColumns = matrix[0].count
        for row in matrix {
            if row.count != firstRowColumns {
                return false
            }
        }
        
        // Kiểm tra số thẻ phải chẵn (để tạo cặp)
        let totalCards = rows * columns
        guard totalCards % 2 == 0 else { return false }
        
        // Kiểm tra có đủ ảnh cho các giá trị unique
        let uniqueValues = Set(matrix.flatMap { $0 })
        guard uniqueValues.count <= imageSet.count else { return false }
        
        return true
    }
    
    // Lấy tên ảnh cho giá trị cụ thể
    func getImageName(for value: Int) -> String {
        let uniqueValues = Array(Set(matrix.flatMap { $0 })).sorted()
        guard let index = uniqueValues.firstIndex(of: value) else {
            return imageSet.first ?? "default"
        }
        return imageSet[index]
    }
    
    // Tạo description cho debug
    var description: String {
        return "Level \(levelNumber): \(rows)x\(columns) grid, \(totalPairs) pairs"
    }
}

// MARK: - Level Creation Helpers
extension Level {
    // Tạo level từ API response
    static func fromAPIResponse(_ response: LevelAPIResponse) -> Level {
        return Level(
            id: response.id,
            levelNumber: response.levelNumber,
            matrix: response.matrix,
            imageSet: response.imageSet,
            timeLimit: response.timeLimit
        )
    }
    
    // Tạo level test đơn giản
    static func createTestLevel(levelNumber: Int = 1) -> Level {
        let matrix = [[1,2,3],[1,2,3],[1,2,3]]
        let imageSet = ["strawberry", "banana", "kiwi"]
        
        return Level(
            id: levelNumber,
            levelNumber: levelNumber,
            matrix: matrix,
            imageSet: imageSet
        )
    }
}
