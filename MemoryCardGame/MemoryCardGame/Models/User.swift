//
//  User.swift
//  MemoryCardGame
//
//  Model cho người chơi
//

import Foundation

// MARK: - User Model
struct User: Codable, Identifiable {
    let id: String
    let username: String
    let currentLevel: Int
    let score: Int
    let createdAt: Date
    
    init(username: String) {
        self.id = UUID().uuidString
        self.username = username
        self.currentLevel = 1
        self.score = 0
        self.createdAt = Date()
    }
}

// MARK: - User Extensions
extension User {
    // Cập nhật điểm số khi hoàn thành level
    mutating func updateScore(newScore: Int) {
        self = User(
            id: self.id,
            username: self.username,
            currentLevel: self.currentLevel,
            score: self.score + newScore,
            createdAt: self.createdAt
        )
    }
    
    // Chuyển sang level tiếp theo
    mutating func advanceToNextLevel() {
        self = User(
            id: self.id,
            username: self.username,
            currentLevel: self.currentLevel + 1,
            score: self.score,
            createdAt: self.createdAt
        )
    }
}

// MARK: - User Initializer cho Codable
extension User {
    init(id: String, username: String, currentLevel: Int, score: Int, createdAt: Date) {
        self.id = id
        self.username = username
        self.currentLevel = currentLevel
        self.score = score
        self.createdAt = createdAt
    }
}
