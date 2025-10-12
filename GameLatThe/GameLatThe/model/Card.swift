
import Foundation

struct Card: Identifiable {
    let id = UUID()
    let contentId: Int
    var isFaceUp = false
    var isMatched = false
}
