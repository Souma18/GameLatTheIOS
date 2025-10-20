import Foundation

// MARK: - API Models
struct GameStartResponse: Codable {
    let username: String
    let level: Int
    let matrix: [[Int]]
    let gridSize: Int
}

struct LevelUpResponse: Codable {
    let username: String
    let newLevel: Int
    let matrix: [[Int]]
    let gridSize: Int
}

// MARK: - Real API Service
class GameAPI {
    static let shared = GameAPI()
    
    private let baseURL = "https://memory-latest-ottn.onrender.com/game"
    
    private init() {}
    
    // MARK: - API Calls
    
    /// Bắt đầu game (POST /game/start)
    func startGame(username: String) async -> GameStartResponse {
        let endpoint = "\(baseURL)/start"
        let body: [String: Any] = ["username": username]
        return await sendRequest(to: endpoint, body: body, username: username, responseType: GameStartResponse.self)
    }
    
    /// Lên level (POST /game/levelup)
    func levelUp(username: String) async -> LevelUpResponse {
        let endpoint = "\(baseURL)/level-up"
        let body: [String: Any] = ["username": username]
        return await sendRequest(to: endpoint, body: body, username: username, responseType: LevelUpResponse.self)
    }
    
    // MARK: - Network Helper
    private func sendRequest<T: Decodable>(
        to urlString: String,
        body: [String: Any],
        username: String,
        responseType: T.Type
    ) async -> T {
        guard let url = URL(string: urlString) else {
            fatalError("❌ URL không hợp lệ: \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("gzip, deflate", forHTTPHeaderField: "Accept-Encoding")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                let err = String(data: data, encoding: .utf8) ?? "Không rõ lỗi"
                print("⚠️ Server trả về lỗi \(httpResponse.statusCode): \(err)")
                throw URLError(.badServerResponse)
            }
            
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
            
        } catch {
            print("❌ Lỗi khi gọi API \(urlString): \(error)")
            
            // Trong trường hợp lỗi, trả về dữ liệu mặc định để không crash game
            if T.self == GameStartResponse.self {
                return GameStartResponse(username: username, level: 1, matrix: [[1, 2], [1, 2]], gridSize: 2) as! T
            } else if T.self == LevelUpResponse.self {
                return LevelUpResponse(username: username, newLevel: 1, matrix: [[1, 2], [1, 2]], gridSize: 2) as! T
            } else {
                fatalError("Không thể xử lý kiểu dữ liệu trả về")
            }
        }
    }
}

// MARK: - Fruit Icons Storage (giữ nguyên)
class FruitIconsStorage {
    static let shared = FruitIconsStorage()
    
    let fruitIcons: [Int: String] = [
        1: "🍓", 2: "🍎", 3: "🍌", 4: "🥝",
        5: "🍇", 6: "🍊", 7: "🥥", 8: "🍍",
        9: "🍉", 10: "🍑", 11: "🍒", 12: "🥭"
    ]
    
    private init() {}
    
    func getIcon(for id: Int) -> String {
        return fruitIcons[id] ?? "❓"
    }
}
