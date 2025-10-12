//
//  Extensions.swift
//  MemoryCardGame
//
//  Utility extensions cho các types cơ bản
//

import SwiftUI
import Foundation

// MARK: - Color Extensions
extension Color {
    
    /// Tạo color từ hex string
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Game theme colors
    static let gamePink = Color(hex: "FF6B9D")
    static let gamePurple = Color(hex: "C44569")
    static let gameLightPink = Color(hex: "F8BBD9")
    static let gameBackground = Color(hex: "FEF7F7")
}

// MARK: - View Extensions
extension View {
    
    /// Thêm shadow với màu custom
    func customShadow(color: Color = .black, radius: CGFloat = 5, x: CGFloat = 0, y: CGFloat = 2) -> some View {
        self.shadow(color: color.opacity(0.2), radius: radius, x: x, y: y)
    }
    
    /// Thêm gradient background
    func gradientBackground(colors: [Color], startPoint: UnitPoint = .topLeading, endPoint: UnitPoint = .bottomTrailing) -> some View {
        self.background(
            LinearGradient(
                colors: colors,
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
    }
    
    /// Thêm animation cho tap gesture
    func tapAnimation(scale: CGFloat = 0.95) -> some View {
        self.scaleEffect(scale)
            .animation(.easeInOut(duration: 0.1), value: scale)
    }
    
    /// Hide keyboard khi tap outside
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - String Extensions
extension String {
    
    /// Kiểm tra string có phải email hợp lệ không
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// Trim whitespace và newlines
    var trimmed: String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /// Capitalize first letter
    var capitalizedFirst: String {
        guard !isEmpty else { return self }
        return prefix(1).capitalized + dropFirst()
    }
    
    /// Tạo random string với độ dài cho trước
    static func random(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
}

// MARK: - Array Extensions
extension Array {
    
    /// Shuffle array in place
    mutating func shuffle() {
        for i in stride(from: count - 1, through: 1, by: -1) {
            let j = Int.random(in: 0...i)
            swapAt(i, j)
        }
    }
    
    /// Tạo shuffled copy của array
    func shuffled() -> [Element] {
        var array = self
        array.shuffle()
        return array
    }
    
    /// Lấy element random từ array
    func randomElement() -> Element? {
        guard !isEmpty else { return nil }
        return self[Int.random(in: 0..<count)]
    }
    
    /// Chia array thành chunks với size cho trước
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

// MARK: - Int Extensions
extension Int {
    
    /// Format số thành string với format cho trước
    func formatted(_ format: String = "%.0f") -> String {
        return String(format: format, Double(self))
    }
    
    /// Kiểm tra số có phải số chẵn không
    var isEven: Bool {
        return self % 2 == 0
    }
    
    /// Kiểm tra số có phải số lẻ không
    var isOdd: Bool {
        return self % 2 != 0
    }
    
    /// Tạo random number trong range
    static func random(in range: Range<Int>) -> Int {
        return Int.random(in: range)
    }
}

// MARK: - Double Extensions
extension Double {
    
    /// Round to số chữ số thập phân
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    /// Format thành string với số chữ số thập phân
    func formatted(decimals: Int = 2) -> String {
        return String(format: "%.\(decimals)f", self)
    }
}

// MARK: - Date Extensions
extension Date {
    
    /// Format date thành string
    func formatted(style: DateFormatter.Style = .medium) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = style
        return formatter.string(from: self)
    }
    
    /// Format date với custom format
    func formatted(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// Tạo date từ string
    static func from(string: String, format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: string)
    }
}

// MARK: - Bundle Extensions
extension Bundle {
    
    /// Lấy app version
    var appVersion: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    /// Lấy build number
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }
    
    /// Lấy app name
    var appName: String {
        return infoDictionary?["CFBundleName"] as? String ?? "App"
    }
}

// MARK: - UserDefaults Extensions
extension UserDefaults {
    
    /// Lưu Codable object
    func setCodable<T: Codable>(_ object: T, forKey key: String) {
        if let data = try? JSONEncoder().encode(object) {
            set(data, forKey: key)
        }
    }
    
    /// Lấy Codable object
    func getCodable<T: Codable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}

// MARK: - NotificationCenter Extensions
extension NotificationCenter {
    
    /// Post notification với custom name
    static func post(name: String, object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(
            name: NSNotification.Name(name),
            object: object,
            userInfo: userInfo
        )
    }
    
    /// Observe notification với custom name
    static func observe(name: String, using block: @escaping (Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.addObserver(
            forName: NSNotification.Name(name),
            object: nil,
            queue: .main,
            using: block
        )
    }
}
