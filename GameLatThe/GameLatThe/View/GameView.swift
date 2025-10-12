import SwiftUI
import Combine

struct GameView: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: 8) {
                Text("🍓 Memory Game 🍇")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.pink, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                
                HStack(spacing: 20) {
                    Text("Level: \(viewModel.currentLevel)")
                    Text("Điểm: \(viewModel.score)")
                    Text("⏱ \(viewModel.timeElapsed)s")
                }
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
                
                Text(viewModel.gameMessage)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(viewModel.isGameOver ? .green : .pink)
                    .padding(.top, 4)
            }
            .padding(.top, 20)
            .padding(.bottom, 10)
            
            // Game Grid - Căn giữa và responsive
            GeometryReader { geometry in
                let availableWidth = geometry.size.width - 40
                let availableHeight = geometry.size.height
                
                // Tính toán số cột và hàng dựa trên tổng số thẻ
                let totalCards = viewModel.cards.count
                let columns = viewModel.gridSize
                let rows = Int(ceil(Double(totalCards) / Double(columns)))
                
                // Tính toán kích thước thẻ để vừa màn hình
                let spacing: CGFloat = 12
                let totalSpacingWidth = CGFloat(columns - 1) * spacing
                let totalSpacingHeight = CGFloat(rows - 1) * spacing
                
                let cardWidthByWidth = (availableWidth - totalSpacingWidth) / CGFloat(columns)
                let cardWidthByHeight = (availableHeight - totalSpacingHeight) / CGFloat(rows)
                
                // Chọn kích thước nhỏ hơn để đảm bảo vừa màn hình
                let cardSize = min(cardWidthByWidth, cardWidthByHeight, 120)
                
                // Tính toán tổng kích thước grid
                let gridWidth = CGFloat(columns) * cardSize + totalSpacingWidth
                let gridHeight = CGFloat(rows) * cardSize + totalSpacingHeight
                
                VStack(spacing: 0) {
                    Spacer()
                    
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.fixed(cardSize), spacing: spacing), count: columns),
                        spacing: spacing
                    ) {
                        ForEach(viewModel.cards) { card in
                            CardView(
                                card: card,
                                size: cardSize,
                                fruitIcon: viewModel.getFruitIcon(for: card.contentId)
                            )
                            .onTapGesture {
                                viewModel.choose(card)
                            }
                        }
                    }
                    .frame(width: gridWidth, height: gridHeight)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
            }
            
            // Buttons
            HStack(spacing: 16) {
                Button(action: { viewModel.restartGame() }) {
                    HStack {
                        Image(systemName: "arrow.clockwise")
                        Text("Chơi Lại")
                    }
                }
                .buttonStyle(GameButtonStyle(backgroundColor: .pink))
                
                if viewModel.isGameOver {
                    Button(action: { viewModel.nextLevel() }) {
                        HStack {
                            Text("Level Tiếp")
                            Image(systemName: "arrow.right")
                        }
                    }
                    .buttonStyle(GameButtonStyle(backgroundColor: .green))
                }
                
                Button(action: { viewModel.logout() }) {
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
                .buttonStyle(GameButtonStyle(backgroundColor: .gray))
            }
            .padding(.vertical, 20)
            .padding(.bottom, 10)
        }
    }
}

// MARK: - Button Style
struct GameButtonStyle: ButtonStyle {
    var backgroundColor: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(.white)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .background(
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [backgroundColor, backgroundColor.opacity(0.8)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .shadow(color: backgroundColor.opacity(0.4), radius: 8, x: 0, y: 4)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: configuration.isPressed)
    }
}
