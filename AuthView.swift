import SwiftUI

struct AuthView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var isSignUp = false
    @State private var email = ""
    @State private var password = ""
    @State private var name = ""
    @State private var selectedRole: AuthManager.UserRole = .renter
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        ZStack {
            // Background
            Color(hex: "0D0D0D").ignoresSafeArea()

            VStack(spacing: 0) {
                // Logo
                VStack(spacing: 8) {
                    Text("encore")
                        .font(.system(size: 52, weight: .black, design: .serif))
                        .italic()
                        .foregroundColor(.white)
                    Text("Rent. Play. Return.")
                        .font(.system(size: 14, weight: .light))
                        .foregroundColor(Color(hex: "8C8375"))
                        .tracking(2)
                }
                .padding(.top, 80)
                .padding(.bottom, 48)

                // Card
                VStack(spacing: 20) {
                    // Toggle
                    HStack(spacing: 0) {
                        tabButton("Sign In",  isActive: !isSignUp) { isSignUp = false }
                        tabButton("Sign Up",  isActive:  isSignUp) { isSignUp = true  }
                    }
                    .background(Color(hex: "1A1A1A"))
                    .cornerRadius(10)

                    if isSignUp {
                        StyledTextField(placeholder: "Full name", text: $name, icon: "person")
                        // Role picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("I want to…").font(.caption).foregroundColor(Color(hex: "8C8375")).padding(.leading, 4)
                            HStack(spacing: 10) {
                                roleCard(role: .renter, icon: "🎸", label: "Rent instruments")
                                roleCard(role: .host,   icon: "🏠", label: "List my instruments")
                            }
                        }
                    }

                    StyledTextField(placeholder: "Email address", text: $email,    icon: "envelope", keyboardType: .emailAddress)
                    StyledTextField(placeholder: "Password",      text: $password, icon: "lock",     isSecure: true)

                    if let err = errorMessage {
                        Text(err)
                            .font(.caption)
                            .foregroundColor(Color(hex: "C4451A"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Button(action: handleAuth) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color(hex: "C4451A"))
                                .frame(height: 52)
                            if isLoading {
                                ProgressView().tint(.white)
                            } else {
                                Text(isSignUp ? "Create Account" : "Sign In")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .disabled(isLoading)
                }
                .padding(24)
                .background(Color(hex: "161616"))
                .cornerRadius(20)
                .padding(.horizontal, 24)

                Spacer()
            }
        }
    }

    // ── Helpers ───────────────────────────────
    private func handleAuth() {
        errorMessage = nil
        isLoading = true

        if isSignUp {
            authManager.signUp(email: email, password: password, name: name, role: selectedRole) { err in
                isLoading = false
                errorMessage = err
            }
        } else {
            authManager.signIn(email: email, password: password) { err in
                isLoading = false
                errorMessage = err
            }
        }
    }

    private func tabButton(_ label: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 14, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isActive ? Color(hex: "C4451A") : Color.clear)
                .foregroundColor(isActive ? .white : Color(hex: "8C8375"))
                .cornerRadius(8)
        }
        .padding(4)
    }

    private func roleCard(role: AuthManager.UserRole, icon: String, label: String) -> some View {
        Button { selectedRole = role } label: {
            VStack(spacing: 6) {
                Text(icon).font(.system(size: 28))
                Text(label)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(selectedRole == role ? .white : Color(hex: "8C8375"))
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(selectedRole == role ? Color(hex: "C4451A").opacity(0.2) : Color(hex: "1A1A1A"))
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(
                selectedRole == role ? Color(hex: "C4451A") : Color(hex: "2A2A2A"), lineWidth: 1.5))
            .cornerRadius(10)
        }
    }
}

// ── Reusable text field ───────────────────────
struct StyledTextField: View {
    let placeholder: String
    @Binding var text: String
    var icon: String = ""
    var keyboardType: UIKeyboardType = .default
    var isSecure = false

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon).foregroundColor(Color(hex: "8C8375")).frame(width: 20)
            if isSecure {
                SecureField(placeholder, text: $text)
                    .foregroundColor(.white)
            } else {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                    .autocapitalization(.none)
                    .foregroundColor(.white)
            }
        }
        .padding(14)
        .background(Color(hex: "1A1A1A"))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "2A2A2A"), lineWidth: 1))
        .cornerRadius(10)
    }
}

// ── Color hex helper ──────────────────────────
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8)  & 0xFF) / 255
        let b = Double(int         & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
