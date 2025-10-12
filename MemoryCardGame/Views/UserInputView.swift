//
//  UserInputView.swift
//  MemoryCardGame
//
//  View để người dùng nhập tên và bắt đầu game
//

import SwiftUI

// MARK: - User Input View
struct UserInputView: View {
    
    // MARK: - Properties
    @StateObject private var apiService = APIService.shared
    @State private var username: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    
    // Callback khi user được tạo thành công
    let onUserCreated: (User) -> Void
    
    // MARK: - Body
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                colors: [.pink.opacity(0.3), .purple.opacity(0.2)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Game Title
                VStack(spacing: 10) {
                    Text("🧠")
                        .font(.system(size: 80))
                    
                    Text("Memory Card Game")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Test your memory skills!")
                        .font(.title3)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Username Input Section
                VStack(spacing: 20) {
                    Text("Enter your name to start")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    VStack(spacing: 15) {
                        // Username TextField
                        TextField("Your name", text: $username)
                            .textFieldStyle(CustomTextFieldStyle())
                            .onSubmit {
                                if !username.isEmpty {
                                    createUser()
                                }
                            }
                        
                        // Start Game Button
                        Button(action: createUser) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Start Game")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 50)
                            .background(
                                LinearGradient(
                                    colors: username.isEmpty ? [.gray] : [.pink, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(color: .pink.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        .disabled(username.isEmpty || isLoading)
                        .animation(.easeInOut(duration: 0.2), value: username.isEmpty)
                    }
                }
                .padding(.horizontal, 30)
                
                Spacer()
                
                // Game Instructions
                VStack(spacing: 8) {
                    Text("How to play:")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("• Flip two cards to find matching pairs")
                        Text("• Complete all pairs to advance to next level")
                        Text("• Try to finish with the least moves possible")
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK") {
                showError = false
            }
        } message: {
            Text(errorMessage)
        }
    }
    
    // MARK: - Private Methods
    
    /// Tạo user mới và bắt đầu game
    private func createUser() {
        guard !username.isEmpty else { return }
        
        isLoading = true
        errorMessage = ""
        
        apiService.createUser(username: username)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    isLoading = false
                    
                    switch completion {
                    case .failure(let error):
                        errorMessage = error.localizedDescription
                        showError = true
                    case .finished:
                        break
                    }
                },
                receiveValue: { user in
                    onUserCreated(user)
                }
            )
            .store(in: &cancellables)
    }
    
    @State private var cancellables = Set<AnyCancellable>()
}

// MARK: - Custom Text Field Style
struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color(.systemBackground))
                    .shadow(color: .pink.opacity(0.2), radius: 3, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 25)
                    .stroke(Color.pink.opacity(0.3), lineWidth: 1)
            )
    }
}

// MARK: - Preview
struct UserInputView_Previews: PreviewProvider {
    static var previews: some View {
        UserInputView { user in
            print("User created: \(user.username)")
        }
    }
}
