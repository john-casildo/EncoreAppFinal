import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        TabView {
            if authManager.userRole == .renter {
                // ── RENTER TABS ──────────────────
                BrowseView()
                    .tabItem { Label("Browse", systemImage: "music.note.list") }

                MyRentalsView()
                    .tabItem { Label("My Rentals", systemImage: "guitar") }

                RenterProfileView()
                    .tabItem { Label("Profile", systemImage: "person.circle") }
            } else {
                // ── HOST TABS ────────────────────
                HostDashboardView()
                    .tabItem { Label("Dashboard", systemImage: "chart.bar.fill") }

                HostListingsView()
                    .tabItem { Label("Listings", systemImage: "music.note.house") }

                HostBookingsView()
                    .tabItem { Label("Bookings", systemImage: "calendar.badge.clock") }

                HostProfileView()
                    .tabItem { Label("Profile", systemImage: "person.circle") }
            }
        }
        .accentColor(Color(hex: "C4451A"))
    }
}
