import SwiftUI

struct RenterProfileView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F0E8").ignoresSafeArea()
                ScrollView {
                    VStack(spacing: 20) {
                        // Avatar + name
                        VStack(spacing: 10) {
                            ZStack {
                                Circle().fill(Color(hex: "C4451A").opacity(0.15)).frame(width: 80, height: 80)
                                Text("🎵").font(.system(size: 36))
                            }
                            Text(authManager.currentUser?.name ?? "Musician")
                                .font(.system(size: 22, weight: .black, design: .serif))
                            Text("Renter")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(Color(hex: "8C8375"))
                                .tracking(1.5)
                        }
                        .padding(.top, 20)

                        // Stats row
                        HStack(spacing: 0) {
                            statBox(value: "2", label: "Active")
                            Divider().frame(height: 40)
                            statBox(value: "8", label: "Completed")
                            Divider().frame(height: 40)
                            statBox(value: "4.9★", label: "Rating")
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Menu
                        VStack(spacing: 0) {
                            menuRow(icon: "heart.fill",       label: "Saved Instruments",   color: "C4451A")
                            menuRow(icon: "bell.fill",        label: "Notifications",        color: "E8A838")
                            menuRow(icon: "creditcard.fill",  label: "Payment Methods",      color: "5A7A5C")
                            menuRow(icon: "questionmark.circle.fill", label: "Help & Support", color: "4A90D9")
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        // Switch to host
                        Button {
                            authManager.userRole = .host
                        } label: {
                            HStack {
                                Image(systemName: "arrow.triangle.2.circlepath")
                                Text("Switch to Host Mode")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(Color(hex: "C4451A"))
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "C4451A").opacity(0.08))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)

                        Button(action: { authManager.signOut() }) {
                            Text("Sign Out")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(hex: "8C8375"))
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white)
                                .cornerRadius(12)
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func statBox(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 22, weight: .black, design: .serif))
                .foregroundColor(Color(hex: "C4451A"))
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(hex: "8C8375"))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
    }

    private func menuRow(icon: String, label: String, color: String) -> some View {
        Button {} label: {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .foregroundColor(Color(hex: color))
                    .frame(width: 24)
                Text(label)
                    .font(.system(size: 15))
                    .foregroundColor(Color(hex: "0D0D0D"))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "8C8375"))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
        .overlay(Divider().padding(.leading, 54), alignment: .bottom)
    }
}
