import SwiftUI

@main
struct MemoryGameApp: App {
    @StateObject private var game = MemoryGameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: game)
        }
    }
}
