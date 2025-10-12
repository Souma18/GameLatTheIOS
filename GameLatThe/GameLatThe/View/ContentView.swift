import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: MemoryGameViewModel
    @State private var inputUsername = ""
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [
                    Color(red: 1.0, green: 0.95, blue: 0.98),
                    Color(red: 1.0, green: 0.85, blue: 0.92)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            if !viewModel.isLoggedIn {
                LoginView(username: $inputUsername) {
                    if !inputUsername.isEmpty {
                        viewModel.startGame(username: inputUsername)
                    }
                }
            } else {
                GameView(viewModel: viewModel)
            }
        }
    }
}

// MARK: - Login View
struct LoginView: View {
    @Binding var username: String
    let onLogin: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Text("🍓 Memory Game 🍇")
                .font(.system(size: 42, weight: .heavy, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.pink, .purple],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
            
            VStack(spacing: 15) {
                TextField("Nhập tên của bạn", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.headline)
                    .padding(.horizontal, 40)
                    .frame(height: 50)
                
                Button(action: onLogin) {
                    Text("Bắt Đầu Chơi")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(
                            LinearGradient(
                                colors: [.pink, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: .pink.opacity(0.5), radius: 10, x: 0, y: 5)
                }
                .disabled(username.isEmpty)
                .opacity(username.isEmpty ? 0.6 : 1.0)
            }
        }
        .padding()
    }
}
