import SwiftUI

struct MyRentalsView: View {
    @State private var rentals = Rental.samples
    @State private var selectedTab = 0

    var active:    [Rental] { rentals.filter { $0.status == .active || $0.status == .confirmed || $0.status == .pending } }
    var completed: [Rental] { rentals.filter { $0.status == .completed || $0.status == .cancelled } }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F0E8").ignoresSafeArea()

                VStack(spacing: 0) {
                    // Custom header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("My Rentals")
                                .font(.system(size: 28, weight: .black, design: .serif))
                            Text("Manage your instrument rentals")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(Color(hex: "8C8375"))
                        }
                        Spacer()
                    }
                    .padding()

                    // Tab selector
                    HStack(spacing: 0) {
                        tabBtn("Active (\(active.count))",    index: 0)
                        tabBtn("History (\(completed.count))", index: 1)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)

                    // List
                    let items = selectedTab == 0 ? active : completed
                    if items.isEmpty {
                        emptyState
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(items) { rental in
                                    RentalCard(rental: rental)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func tabBtn(_ label: String, index: Int) -> some View {
        Button { selectedTab = index } label: {
            Text(label)
                .font(.system(size: 13, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(selectedTab == index ? Color(hex: "0D0D0D") : Color.clear)
                .foregroundColor(selectedTab == index ? Color(hex: "F5F0E8") : Color(hex: "8C8375"))
                .cornerRadius(8)
        }
        .padding(3)
        .background(Color(hex: "E8E0D0"))
        .cornerRadius(10)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Text("🎸").font(.system(size: 56))
            Text("No rentals yet")
                .font(.system(size: 20, weight: .bold, design: .serif))
            Text(selectedTab == 0
                 ? "Browse instruments and make your first reservation!"
                 : "Your completed rentals will appear here.")
                .font(.system(size: 14, weight: .light))
                .foregroundColor(Color(hex: "8C8375"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.top, 60)
    }
}

// ── Rental Card ───────────────────────────────
struct RentalCard: View {
    let rental: Rental

    var statusColor: Color {
        switch rental.status {
        case .active:    return Color(hex: "5A7A5C")
        case .confirmed: return Color(hex: "E8A838")
        case .pending:   return Color(hex: "8C8375")
        case .completed: return Color(hex: "4A90D9")
        case .cancelled: return Color(hex: "C4451A")
        }
    }

    var body: some View {
        HStack(spacing: 14) {
            // Emoji
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "EDE5D5"))
                    .frame(width: 64, height: 64)
                Text(rental.instrumentEmoji).font(.system(size: 32))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(rental.instrumentName)
                    .font(.system(size: 15, weight: .bold))
                Text("\(rental.startDate) → \(rental.endDate)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "8C8375"))
                HStack(spacing: 8) {
                    Text(rental.status.rawValue.capitalized)
                        .font(.system(size: 11, weight: .semibold))
                        .padding(.horizontal, 8).padding(.vertical, 3)
                        .background(statusColor.opacity(0.15))
                        .foregroundColor(statusColor)
                        .cornerRadius(6)
                    Text("\(rental.daysCount) days")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8C8375"))
                }
            }

            Spacer()

            Text("$\(Int(rental.totalPrice))")
                .font(.system(size: 17, weight: .black))
                .foregroundColor(Color(hex: "C4451A"))
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}
