import SwiftUI

struct HostProfileView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "0D0D0D").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Avatar
                        VStack(spacing: 10) {
                            ZStack {
                                Circle().fill(Color(hex: "C4451A").opacity(0.2)).frame(width: 80, height: 80)
                                Text("🏠").font(.system(size: 36))
                            }
                            Text(authManager.currentUser?.name ?? "Host")
                                .font(.system(size: 22, weight: .black, design: .serif))
                                .foregroundColor(.white)
                            Text("Instrument Host")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "8C8375"))
                                .tracking(1.5)
                        }
                        .padding(.top, 20)

                        // Stats
                        HStack(spacing: 0) {
                            darkStat(value: "$1,520", label: "Earned")
                            Divider().frame(height: 40).background(Color(hex: "2A2A2A"))
                            darkStat(value: "4",      label: "Listings")
                            Divider().frame(height: 40).background(Color(hex: "2A2A2A"))
                            darkStat(value: "12",     label: "Rentals")
                        }
                        .background(Color(hex: "161616"))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "2A2A2A"), lineWidth: 1))
                        .padding(.horizontal)

                        // Menu
                        VStack(spacing: 0) {
                            darkMenuRow(icon: "banknote.fill",    label: "Payout Settings",    color: "5A7A5C")
                            darkMenuRow(icon: "shield.fill",      label: "Host Protection",    color: "4A90D9")
                            darkMenuRow(icon: "bell.fill",        label: "Notifications",      color: "E8A838")
                            darkMenuRow(icon: "chart.bar.fill",   label: "Analytics",          color: "C4451A")
                            darkMenuRow(icon: "questionmark.circle.fill", label: "Help",       color: "8C8375")
                        }
                        .background(Color(hex: "161616"))
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "2A2A2A"), lineWidth: 1))
                        .padding(.horizontal)

                        // Switch to renter
                        Button { authManager.userRole = .renter } label: {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text("Switch to Renter Mode")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(Color(hex: "C4451A"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "C4451A").opacity(0.1))
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "C4451A").opacity(0.3), lineWidth: 1))
                        }
                        .padding(.horizontal)

                        Button { authManager.signOut() } label: {
                            Text("Sign Out")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "8C8375"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "161616"))
                                .cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color(hex: "2A2A2A"), lineWidth: 1))
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func darkStat(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .black, design: .serif))
                .foregroundColor(Color(hex: "C4451A"))
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "8C8375"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }

    private func darkMenuRow(icon: String, label: String, color: String) -> some View {
        Button {} label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: color))
                    .frame(width: 24)
                Text(label)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "555555"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .overlay(
            Divider().background(Color(hex: "2A2A2A")).padding(.leading, 54),
            alignment: .bottom
        )
    }
}
