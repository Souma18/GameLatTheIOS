//
//  APIService.swift
//  MemoryCardGame
//
//  Service giao tiếp với API server để lấy level data
//

import Foundation
import Combine

// MARK: - API Models
struct LevelAPIResponse: Codable {
    let id: Int
    let levelNumber: Int
    let matrix: [[Int]]
    let imageSet: [String]
    let timeLimit: Int?
    let success: Bool
    let message: String?
}

struct GameResultResponse: Codable {
    let success: Bool
    let score: Int
    let nextLevel: Int?
    let message: String?
}

struct UserRequest: Codable {
    let username: String
    let currentLevel: Int
}

// MARK: - API Service Protocol
protocol APIServiceProtocol {
    func requestLevel(levelNumber: Int, username: String) -> AnyPublisher<LevelAPIResponse, Error>
    func submitGameResult(username: String, levelNumber: Int, score: Int, moves: Int) -> AnyPublisher<GameResultResponse, Error>
    func createUser(username: String) -> AnyPublisher<User, Error>
}

// MARK: - API Service Implementation
class APIService: APIServiceProtocol, ObservableObject {
    
    // MARK: - Singleton
    static let shared = APIService()
    
    // MARK: - Configuration
    private let baseURL = "https://api.memorygame.com" // Thay đổi theo server thực tế
    private let session = URLSession.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Mock Data (để test khi không có server thật)
    private let isUsingMockData = true // Set false khi có server thật
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Gửi request lấy level data từ server
    func requestLevel(levelNumber: Int, username: String) -> AnyPublisher<LevelAPIResponse, Error> {
        if isUsingMockData {
            return getMockLevel(levelNumber: levelNumber)
        }
        
        return Future<LevelAPIResponse, Error> { promise in
            self.performRequest(
                endpoint: "/levels/\(levelNumber)",
                method: "GET",
                body: nil
            ) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(LevelAPIResponse.self, from: data)
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Gửi kết quả game lên server
    func submitGameResult(username: String, levelNumber: Int, score: Int, moves: Int) -> AnyPublisher<GameResultResponse, Error> {
        if isUsingMockData {
            return getMockGameResult(levelNumber: levelNumber, score: score)
        }
        
        let requestBody = [
            "username": username,
            "levelNumber": levelNumber,
            "score": score,
            "moves": moves
        ]
        
        return Future<GameResultResponse, Error> { promise in
            self.performRequest(
                endpoint: "/game/result",
                method: "POST",
                body: requestBody
            ) { result in
                switch result {
                case .success(let data):
                    do {
                        let response = try JSONDecoder().decode(GameResultResponse.self, from: data)
                        promise(.success(response))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    /// Tạo user mới
    func createUser(username: String) -> AnyPublisher<User, Error> {
        if isUsingMockData {
            return getMockUser(username: username)
        }
        
        let requestBody = ["username": username]
        
        return Future<User, Error> { promise in
            self.performRequest(
                endpoint: "/users",
                method: "POST",
                body: requestBody
            ) { result in
                switch result {
                case .success(let data):
                    do {
                        let user = try JSONDecoder().decode(User.self, from: data)
                        promise(.success(user))
                    } catch {
                        promise(.failure(error))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // MARK: - Private Methods
    
    private func performRequest(
        endpoint: String,
        method: String,
        body: [String: Any]?,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body)
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    // MARK: - Mock Data Methods
    
    private func getMockLevel(levelNumber: Int) -> AnyPublisher<LevelAPIResponse, Error> {
        return Future<LevelAPIResponse, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let mockResponse = self.createMockLevelResponse(levelNumber: levelNumber)
                promise(.success(mockResponse))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getMockGameResult(levelNumber: Int, score: Int) -> AnyPublisher<GameResultResponse, Error> {
        return Future<GameResultResponse, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let mockResponse = GameResultResponse(
                    success: true,
                    score: score,
                    nextLevel: levelNumber + 1,
                    message: "Level completed successfully!"
                )
                promise(.success(mockResponse))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func getMockUser(username: String) -> AnyPublisher<User, Error> {
        return Future<User, Error> { promise in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let user = User(username: username)
                promise(.success(user))
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func createMockLevelResponse(levelNumber: Int) -> LevelAPIResponse {
        let levelService = LevelService.shared
        let level = levelService.generateLevel(levelNumber: levelNumber) ?? levelService.createTestLevel()
        
        return LevelAPIResponse(
            id: level.id,
            levelNumber: level.levelNumber,
            matrix: level.matrix,
            imageSet: level.imageSet,
            timeLimit: level.timeLimit,
            success: true,
            message: "Level \(levelNumber) loaded successfully"
        )
    }
}

// MARK: - API Error Types
enum APIError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError
    case networkError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodingError:
            return "Failed to decode response"
        case .networkError(let message):
            return "Network error: \(message)"
        }
    }
}

// MARK: - API Service Extensions
extension APIService {
    // Test connection với server
    func testConnection() -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            // Implement ping test
            promise(.success(true))
        }
        .eraseToAnyPublisher()
    }
    
    // Get leaderboard
    func getLeaderboard() -> AnyPublisher<[User], Error> {
        return Future<[User], Error> { promise in
            // Implement leaderboard
            promise(.success([]))
        }
        .eraseToAnyPublisher()
    }
}
