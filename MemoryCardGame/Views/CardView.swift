//
//  CardView.swift
//  MemoryCardGame
//
//  Component hiển thị một thẻ bài trong game
//

import SwiftUI

// MARK: - Card View
struct CardView: View {
    
    // MARK: - Properties
    let card: Card
    let imageManager = ImageManager.shared
    @State private var isAnimating: Bool = false
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 12)
                .fill(cardBackground)
                .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowOffset)
            
            // Card content
            if card.isFaceUp {
                // Front side - show image
                cardFrontContent
            } else {
                // Back side - show card back
                cardBackContent
            }
        }
        .scaleEffect(isAnimating ? 1.05 : 1.0)
        .rotation3DEffect(
            .degrees(card.isFaceUp ? 0 : 180),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: card.isFaceUp)
        .onTapGesture {
            if !card.isMatched {
                flipCard()
            }
        }
        .onAppear {
            // Reset animation state
            isAnimating = false
        }
    }
    
    // MARK: - Card Background
    private var cardBackground: some ShapeStyle {
        if card.isMatched {
            return LinearGradient(
                colors: [.green.opacity(0.3), .green.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else if card.isFaceUp {
            return LinearGradient(
                colors: [.white, .pink.opacity(0.1)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            return LinearGradient(
                colors: [.pink.opacity(0.6), .pink.opacity(0.4)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }
    
    // MARK: - Shadow Properties
    private var shadowColor: Color {
        if card.isMatched {
            return .green.opacity(0.3)
        } else if card.isFaceUp {
            return .pink.opacity(0.2)
        } else {
            return .pink.opacity(0.4)
        }
    }
    
    private var shadowRadius: CGFloat {
        card.isFaceUp ? 2 : 4
    }
    
    private var shadowOffset: CGFloat {
        card.isFaceUp ? 1 : 2
    }
    
    // MARK: - Card Front Content
    private var cardFrontContent: some View {
        VStack {
            // Card image
            if let image = imageManager.getImage(named: card.imageName) {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(8)
            } else {
                // Fallback emoji
                Text(emojiForImageName(card.imageName))
                    .font(.system(size: 40))
            }
            
            // Match indicator
            if card.isMatched {
                VStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
                .padding(.bottom, 4)
            }
        }
    }
    
    // MARK: - Card Back Content
    private var cardBackContent: some View {
        VStack {
            Spacer()
            
            // Card back icon
            Image(systemName: "questionmark.circle.fill")
                .font(.system(size: 30))
                .foregroundColor(.white)
            
            Spacer()
            
            // Card pattern (optional)
            HStack(spacing: 4) {
                ForEach(0..<3) { _ in
                    Circle()
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 4, height: 4)
                }
            }
            .padding(.bottom, 8)
        }
    }
    
    // MARK: - Private Methods
    
    /// Flip card animation
    private func flipCard() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isAnimating = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                isAnimating = false
            }
        }
    }
    
    /// Get emoji for image name (fallback)
    private func emojiForImageName(_ imageName: String) -> String {
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
}

// MARK: - Card View Extensions
extension CardView {
    
    /// Create card view with custom size
    static func withSize(_ size: CGFloat) -> some View {
        CardView(card: Card(value: 1, imageName: "strawberry"))
            .frame(width: size, height: size)
    }
    
    /// Create matched card view
    static func matched(value: Int, imageName: String) -> some View {
        var card = Card(value: value, imageName: imageName)
        card.markAsMatched()
        return CardView(card: card)
    }
    
    /// Create face up card view
    static func faceUp(value: Int, imageName: String) -> some View {
        var card = Card(value: value, imageName: imageName)
        card.flipUp()
        return CardView(card: card)
    }
}

// MARK: - Preview
struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            HStack(spacing: 20) {
                // Face down card
                CardView(card: Card(value: 1, imageName: "strawberry"))
                    .frame(width: 80, height: 80)
                
                // Face up card
                CardView(card: {
                    var card = Card(value: 2, imageName: "banana")
                    card.flipUp()
                    return card
                }())
                    .frame(width: 80, height: 80)
                
                // Matched card
                CardView(card: {
                    var card = Card(value: 3, imageName: "kiwi")
                    card.markAsMatched()
                    return card
                }())
                    .frame(width: 80, height: 80)
            }
            
            Text("Card Examples")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding()
    }
}
