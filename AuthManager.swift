import Foundation
import SwiftUI

class AuthManager: ObservableObject {
    @Published var isLoggedIn = false
    @Published var currentUser: AppUser?
    @Published var userRole: UserRole = .renter  // renter or host

    enum UserRole: String, CaseIterable {
        case renter = "renter"
        case host   = "host"
    }

    // ── Sign Up ──────────────────────────────
    func signUp(
        email: String,
        password: String,
        name: String,
        role: UserRole,
        completion: @escaping (String?) -> Void   // returns error message or nil
    ) {
        guard let url = URL(string: "\(SupabaseConfig.url)/auth/v1/signup") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "email": email,
            "password": password,
            "data": ["name": name, "role": role.rawValue]
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error { completion(error.localizedDescription); return }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                else { completion("Unknown error"); return }

                if let errMsg = json["error_description"] as? String {
                    completion(errMsg)
                } else if let token = (json["session"] as? [String: Any])?["access_token"] as? String {
                    self.handleSession(json: json, token: token, name: name, role: role)
                    completion(nil)
                } else {
                    // Email confirmation required
                    completion("Check your email to confirm your account, then sign in.")
                }
            }
        }.resume()
    }

    // ── Sign In ──────────────────────────────
    func signIn(
        email: String,
        password: String,
        completion: @escaping (String?) -> Void
    ) {
        guard let url = URL(string: "\(SupabaseConfig.url)/auth/v1/token?grant_type=password") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["email": email, "password": password]
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            DispatchQueue.main.async {
                if let error = error { completion(error.localizedDescription); return }
                guard let data = data,
                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                else { completion("Unknown error"); return }

                if let errMsg = json["error_description"] as? String {
                    completion(errMsg)
                } else if let token = json["access_token"] as? String {
                    let name = ((json["user"] as? [String: Any])?["user_metadata"] as? [String: Any])?["name"] as? String ?? "User"
                    let roleStr = ((json["user"] as? [String: Any])?["user_metadata"] as? [String: Any])?["role"] as? String ?? "renter"
                    let role = UserRole(rawValue: roleStr) ?? .renter
                    self.handleSession(json: json, token: token, name: name, role: role)
                    completion(nil)
                } else {
                    completion("Invalid credentials")
                }
            }
        }.resume()
    }

    // ── Sign Out ─────────────────────────────
    func signOut() {
        SupabaseClient.shared.setToken(nil)
        currentUser = nil
        isLoggedIn = false
    }

    // ── Internal ─────────────────────────────
    private func handleSession(json: [String: Any], token: String, name: String, role: UserRole) {
        SupabaseClient.shared.setToken(token)
        let userId = (json["user"] as? [String: Any])?["id"] as? String ?? UUID().uuidString
        self.currentUser = AppUser(id: userId, name: name, email: "", role: role.rawValue)
        self.userRole = role
        self.isLoggedIn = true
    }
}
