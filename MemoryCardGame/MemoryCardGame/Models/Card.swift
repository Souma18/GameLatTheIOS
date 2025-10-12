//
//  Card.swift
//  MemoryCardGame
//
//  Model cho thẻ bài trong game
//

import Foundation

// MARK: - Card Model
struct Card: Codable, Identifiable {
    let id: String
    let value: Int              // Giá trị để so sánh (1,2,3...)
    let imageName: String       // Tên file ảnh
    var isFaceUp: Bool = false  // Trạng thái lật ngửa/úp
    var isMatched: Bool = false // Trạng thái đã match
    var isFlipped: Bool = false // Trạng thái đang lật (để animation)
    
    init(value: Int, imageName: String) {
        self.id = UUID().uuidString
        self.value = value
        self.imageName = imageName
    }
}

// MARK: - Card Extensions
extension Card {
    // Lật thẻ lên
    mutating func flipUp() {
        self.isFaceUp = true
        self.isFlipped = true
    }
    
    // Úp thẻ xuống
    mutating func flipDown() {
        self.isFaceUp = false
        self.isFlipped = false
    }
    
    // Đánh dấu đã match
    mutating func markAsMatched() {
        self.isMatched = true
        self.isFaceUp = true
    }
    
    // Reset thẻ về trạng thái ban đầu
    mutating func reset() {
        self.isFaceUp = false
        self.isMatched = false
        self.isFlipped = false
    }
}

// MARK: - Card Comparison
extension Card: Equatable {
    static func == (lhs: Card, rhs: Card) -> Bool {
        return lhs.value == rhs.value && lhs.id == rhs.id
    }
}
