//
//  ImageManager.swift
//  MemoryCardGame
//
//  Service quản lý ảnh và assets động
//

import Foundation
import SwiftUI
import Combine

// MARK: - Image Manager Protocol
protocol ImageManagerProtocol {
    func getImage(named imageName: String) -> Image?
    func preloadImages(_ imageNames: [String])
    func getCardBackImage() -> Image
    func getCardFrontImage(for value: Int, imageSet: [String]) -> Image?
}

// MARK: - Image Manager Implementation
class ImageManager: ImageManagerProtocol, ObservableObject {
    
    // MARK: - Singleton
    static let shared = ImageManager()
    
    // MARK: - Properties
    private var imageCache: [String: Image] = [:]
    private let cardBackImageName = "card_back"
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Available Images
    private let availableImages = [
        "strawberry", "banana", "kiwi", "orange", "grape",
        "apple", "cherry", "lemon", "peach", "pear",
        "watermelon", "pineapple", "mango", "blueberry", "raspberry"
    ]
    
    private init() {
        preloadDefaultImages()
    }
    
    // MARK: - Public Methods
    
    /// Lấy ảnh theo tên
    func getImage(named imageName: String) -> Image? {
        // Kiểm tra cache trước
        if let cachedImage = imageCache[imageName] {
            return cachedImage
        }
        
        // Tạo ảnh mới và cache
        let image = createImage(named: imageName)
        imageCache[imageName] = image
        
        return image
    }
    
    /// Preload nhiều ảnh cùng lúc
    func preloadImages(_ imageNames: [String]) {
        for imageName in imageNames {
            if imageCache[imageName] == nil {
                let image = createImage(named: imageName)
                imageCache[imageName] = image
            }
        }
    }
    
    /// Lấy ảnh mặt sau thẻ
    func getCardBackImage() -> Image {
        return getImage(named: cardBackImageName) ?? createDefaultCardBack()
    }
    
    /// Lấy ảnh mặt trước thẻ theo value
    func getCardFrontImage(for value: Int, imageSet: [String]) -> Image? {
        guard value > 0 && value <= imageSet.count else {
            return getDefaultCardImage()
        }
        
        let imageName = imageSet[value - 1]
        return getImage(named: imageName)
    }
    
    // MARK: - Private Methods
    
    /// Tạo ảnh từ tên
    private func createImage(named imageName: String) -> Image {
        // Thử load từ Assets
        if let assetImage = Image(imageName) {
            return assetImage
        }
        
        // Fallback: tạo ảnh emoji hoặc SF Symbol
        return createFallbackImage(for: imageName)
    }
    
    /// Tạo ảnh fallback khi không tìm thấy asset
    private func createFallbackImage(for imageName: String) -> Image {
        let emoji = getEmojiForImageName(imageName)
        return Image(systemName: "photo.fill") // SF Symbol fallback
            .foregroundColor(.pink)
    }
    
    /// Lấy emoji tương ứng với tên ảnh
    private func getEmojiForImageName(_ imageName: String) -> String {
        let emojiMap: [String: String] = [
            "strawberry": "🍓",
            "banana": "🍌",
            "kiwi": "🥝",
            "orange": "🍊",
            "grape": "🍇",
            "apple": "🍎",
            "cherry": "🍒",
            "lemon": "🍋",
            "peach": "🍑",
            "pear": "🍐",
            "watermelon": "🍉",
            "pineapple": "🍍",
            "mango": "🥭",
            "blueberry": "🫐",
            "raspberry": "🫐"
        ]
        
        return emojiMap[imageName] ?? "❓"
    }
    
    /// Tạo ảnh mặt sau thẻ mặc định
    private func createDefaultCardBack() -> Image {
        return Image(systemName: "questionmark.circle.fill")
            .foregroundColor(.pink)
    }
    
    /// Tạo ảnh thẻ mặc định
    private func getDefaultCardImage() -> Image {
        return Image(systemName: "photo.fill")
            .foregroundColor(.gray)
    }
    
    /// Preload các ảnh mặc định
    private func preloadDefaultImages() {
        preloadImages(availableImages)
        
        // Preload card back
        imageCache[cardBackImageName] = createDefaultCardBack()
    }
    
    // MARK: - Cache Management
    
    /// Clear cache để tiết kiệm memory
    func clearCache() {
        imageCache.removeAll()
        preloadDefaultImages()
    }
    
    /// Get cache size
    func getCacheSize() -> Int {
        return imageCache.count
    }
}

// MARK: - Image Manager Extensions
extension ImageManager {
    
    /// Tạo ảnh với gradient background (cho card)
    func createCardBackground(isFaceUp: Bool) -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(
                LinearGradient(
                    colors: isFaceUp ? [.pink.opacity(0.3), .pink.opacity(0.1)] : [.pink.opacity(0.6), .pink.opacity(0.4)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .shadow(color: .pink.opacity(0.3), radius: isFaceUp ? 2 : 4, x: 0, y: 2)
    }
    
    /// Tạo ảnh với animation effect
    func createAnimatedCardImage(_ image: Image, isFlipped: Bool) -> some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .scaleEffect(isFlipped ? 1.0 : 0.1)
            .opacity(isFlipped ? 1.0 : 0.0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8), value: isFlipped)
    }
    
    /// Validate image name có tồn tại không
    func isValidImageName(_ imageName: String) -> Bool {
        return availableImages.contains(imageName)
    }
    
    /// Get all available image names
    func getAllAvailableImages() -> [String] {
        return availableImages
    }
}

// MARK: - Async Image Loading (cho ảnh từ URL)
extension ImageManager {
    
    /// Load ảnh từ URL (nếu cần)
    func loadImageFromURL(_ url: URL) -> AnyPublisher<Image?, Never> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { data, _ in
                // Convert data to Image nếu cần
                return nil // Placeholder
            }
            .replaceError(with: nil)
            .eraseToAnyPublisher()
    }
}
