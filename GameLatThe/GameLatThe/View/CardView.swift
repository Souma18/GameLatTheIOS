import SwiftUI
struct CardView: View {
    let card: Card
    let size: CGFloat
    let fruitIcon: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .overlay(
                    Group {
                        if card.isFaceUp {
                            Text(fruitIcon)
                                .font(.system(size: size * 0.6))
                        } else if !card.isFaceUp {
                            Image(systemName: "apple.logo")
                                .font(.system(size: size * 0.4))
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                )
                .frame(width: size, height: size)
                .background(card.isFaceUp ? Color.white : Color.pink)
                .cornerRadius(12)
                .shadow(color: .pink.opacity(0.3), radius: card.isMatched ? 0 : 5)
                .opacity(card.isMatched ? 0.5 : 1.0)
                .scaleEffect(card.isMatched ? 1.1 : 1.0)
                .rotation3DEffect(.degrees(card.isFaceUp ? 180 : 0), axis: (x: 0, y: 1, z: 0))
                .animation(.easeInOut(duration: 0.5), value: card.isFaceUp)
                .animation(.spring(), value: card.isMatched)
        }
    }
}
