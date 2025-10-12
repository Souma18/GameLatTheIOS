# 🧠 Memory Card Game

Một game lật thẻ tìm cặp được phát triển bằng Swift và SwiftUI cho macOS/iOS.

## ✨ Tính năng

- **Dynamic Level System**: Hệ thống level động với ma trận có thể thay đổi kích thước
- **API Integration**: Tích hợp API để lấy level data từ server
- **Beautiful UI**: Giao diện đẹp mắt với animation mượt mà
- **User Management**: Quản lý người dùng và điểm số
- **Responsive Design**: Tự động adapt với các kích thước màn hình khác nhau

## 🏗️ Kiến trúc

### Models
- `User.swift` - Model cho người chơi
- `Card.swift` - Model cho thẻ bài
- `Level.swift` - Model cho level và ma trận
- `GameState.swift` - Model cho trạng thái game

### Services
- `LevelService.swift` - Xử lý logic level và ma trận
- `APIService.swift` - Giao tiếp với server API
- `ImageManager.swift` - Quản lý ảnh và assets

### Views
- `UserInputView.swift` - Màn hình nhập tên người chơi
- `GameView.swift` - Màn hình game chính
- `CardView.swift` - Component hiển thị thẻ bài
- `ContentView.swift` - Main navigation controller

## 🚀 Cách chạy

### Yêu cầu
- Xcode 14.0+
- iOS 15.0+ / macOS 12.0+
- Swift 5.7+

### Cài đặt
1. Clone repository
2. Mở `MemoryCardGame.xcodeproj` trong Xcode
3. Chọn target device/simulator
4. Nhấn ⌘+R để build và chạy

### Cấu hình API
Trong `APIService.swift`, thay đổi:
```swift
private let baseURL = "https://your-api-server.com"
private let isUsingMockData = false // Set true để dùng mock data
```

## 🎮 Cách chơi

1. **Nhập tên**: Nhập tên người chơi và nhấn "Start Game"
2. **Lật thẻ**: Tap vào 2 thẻ để tìm cặp giống nhau
3. **Tìm cặp**: Nếu 2 thẻ giống nhau, chúng sẽ được giữ lại
4. **Hoàn thành**: Tìm tất cả các cặp để hoàn thành level
5. **Level tiếp theo**: Tự động chuyển sang level khó hơn

## 🔧 API Endpoints

### Request Level
```
GET /levels/{levelNumber}
Response: {
  "id": 1,
  "levelNumber": 1,
  "matrix": [[1,2,3],[1,2,3],[1,2,3]],
  "imageSet": ["strawberry", "banana", "kiwi"],
  "timeLimit": 120,
  "success": true
}
```

### Submit Result
```
POST /game/result
Body: {
  "username": "Player123",
  "levelNumber": 1,
  "score": 100,
  "moves": 15
}
Response: {
  "success": true,
  "score": 100,
  "nextLevel": 2,
  "message": "Level completed!"
}
```

## 🎨 Customization

### Thêm ảnh mới
1. Thêm ảnh vào `Assets.xcassets`
2. Cập nhật `availableImages` trong `ImageManager.swift`
3. Thêm emoji fallback trong `getEmojiForImageName()`

### Thay đổi theme
Sửa màu sắc trong các file View:
```swift
LinearGradient(
    colors: [.yourColor1, .yourColor2],
    startPoint: .topLeading,
    endPoint: .bottomTrailing
)
```

### Thêm level mới
Trong `LevelService.swift`:
```swift
private func createLevel4() -> Level {
    let matrix = [[1,2,3,4,5,6],[1,2,3,4,5,6],[1,2,3,4,5,6],[1,2,3,4,5,6],[1,2,3,4,5,6],[1,2,3,4,5,6]]
    let imageSet = ["img1", "img2", "img3", "img4", "img5", "img6"]
    
    return Level(
        id: 4,
        levelNumber: 4,
        matrix: matrix,
        imageSet: imageSet,
        timeLimit: 300
    )
}
```

## 🐛 Debug

### Logs
App sẽ in ra console các thông tin debug:
- 🎮 Game initialization
- 📱 App state changes
- 🌐 API requests/responses
- ⚠️ Error messages

### Mock Data
Set `isUsingMockData = true` trong `APIService.swift` để test offline.

## 📱 Screenshots

### User Input Screen
- Nhập tên người chơi
- Giao diện đẹp với gradient background
- Instructions về cách chơi

### Game Screen
- Grid thẻ bài với animation
- Header hiển thị level và player info
- Score và moves counter
- Replay button

## 🤝 Contributing

1. Fork repository
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request

## 📄 License

MIT License - xem file LICENSE để biết thêm chi tiết.

## 🙏 Acknowledgments

- SwiftUI framework
- Combine framework
- Apple Human Interface Guidelines
- Game design inspiration từ các memory games phổ biến

---

**Phát triển bởi**: Memory Card Game Team  
**Phiên bản**: 1.0.0  
**Cập nhật lần cuối**: 2024
