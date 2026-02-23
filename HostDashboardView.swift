import SwiftUI

struct HostDashboardView: View {
    @EnvironmentObject var authManager: AuthManager

    // Sample earnings data
    let monthlyEarnings: [(month: String, amount: Double)] = [
        ("Jan", 120), ("Feb", 200), ("Mar", 160), ("Apr", 340), ("May", 280), ("Jun", 420)
    ]
    let maxEarning: Double = 420

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D0D").ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Header
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Welcome back,")
                                    .font(.system(size: 14, weight: .light))
                                    .foregroundColor(Color(hex: "8C8375"))
                                Text(authManager.currentUser?.name ?? "Host")
                                    .font(.system(size: 26, weight: .black, design: .serif))
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            ZStack {
                                Circle().fill(Color(hex: "1A1A1A")).frame(width: 44, height: 44)
                                Text("🎵").font(.system(size: 20))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 12)

                        // Total earnings card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("TOTAL EARNINGS")
                                .font(.system(size: 11, weight: .semibold))
                                .foregroundColor(Color(hex: "8C8375"))
                                .tracking(1.5)
                            Text("$1,520")
                                .font(.system(size: 44, weight: .black, design: .serif))
                                .foregroundColor(.white)
                            Text("+$420 this month")
                                .font(.system(size: 13))
                                .foregroundColor(Color(hex: "5A7A5C"))
                        }
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color(hex: "161616"))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "2A2A2A"), lineWidth: 1))
                        .padding(.horizontal)

                        // Stats row
                        HStack(spacing: 12) {
                            miniStat(value: "4",  label: "Listings",    icon: "music.note.house")
                            miniStat(value: "12", label: "Bookings",    icon: "calendar.badge.clock")
                            miniStat(value: "4.8", label: "Rating",     icon: "star.fill")
                        }
                        .padding(.horizontal)

                        // Bar chart
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Monthly Earnings")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)

                            HStack(alignment: .bottom, spacing: 8) {
                                ForEach(monthlyEarnings, id: \.month) { item in
                                    VStack(spacing: 6) {
                                        Text("$\(Int(item.amount))")
                                            .font(.system(size: 9))
                                            .foregroundColor(Color(hex: "8C8375"))
                                        RoundedRectangle(cornerRadius: 4)
                                            .fill(item.amount == maxEarning
                                                  ? Color(hex: "C4451A")
                                                  : Color(hex: "2A2A2A"))
                                            .frame(height: CGFloat(item.amount / maxEarning) * 100)
                                        Text(item.month)
                                            .font(.system(size: 10))
                                            .foregroundColor(Color(hex: "8C8375"))
                                    }
                                    .frame(maxWidth: .infinity)
                                }
                            }
                            .frame(height: 130)
                        }
                        .padding(20)
                        .background(Color(hex: "161616"))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "2A2A2A"), lineWidth: 1))
                        .padding(.horizontal)

                        // Recent activity
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Recent Activity")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)

                            activityRow(emoji: "🎸", name: "Marco V.", action: "booked Stratocaster", time: "2h ago", isNew: true)
                            activityRow(emoji: "🎹", name: "Sofia R.", action: "returned Yamaha P-125", time: "Yesterday", isNew: false)
                            activityRow(emoji: "🥁", name: "James K.", action: "booked Pearl Drums", time: "2 days ago", isNew: false)
                        }
                        .padding(20)
                        .background(Color(hex: "161616"))
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(hex: "2A2A2A"), lineWidth: 1))
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func miniStat(value: String, label: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(Color(hex: "C4451A"))
                .font(.system(size: 18))
            Text(value)
                .font(.system(size: 22, weight: .black, design: .serif))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "8C8375"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(hex: "161616"))
        .cornerRadius(12)
        .overlay(RoundedRectangle(cornerRadius: 12)
            .stroke(Color(hex: "2A2A2A"), lineWidth: 1))
    }

    private func activityRow(emoji: String, name: String, action: String, time: String, isNew: Bool) -> some View {
        HStack(spacing: 12) {
            Text(emoji).font(.system(size: 24))
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name).font(.system(size: 13, weight: .semibold)).foregroundColor(.white)
                    if isNew {
                        Text("NEW")
                            .font(.system(size: 9, weight: .bold))
                            .padding(.horizontal, 5).padding(.vertical, 2)
                            .background(Color(hex: "C4451A"))
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                }
                Text(action).font(.system(size: 12)).foregroundColor(Color(hex: "8C8375"))
            }
            Spacer()
            Text(time).font(.system(size: 11)).foregroundColor(Color(hex: "555555"))
        }
    }
}
