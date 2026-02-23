import SwiftUI

@main
struct EncoreApp: App {
    @StateObject private var authManager = AuthManager()

    var body: some Scene {
        WindowGroup {
            if authManager.isLoggedIn {
                MainTabView()
                    .environmentObject(authManager)
            } else {
                AuthView()
                    .environmentObject(authManager)
            }
        }
    }
}
