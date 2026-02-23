import SwiftUI

struct HostBookingsView: View {
    @State private var bookings = Rental.samples + [
        Rental(id: "r3", instrumentId: "1", renterId: "u3", hostId: "me",
               startDate: "2025-06-20", endDate: "2025-06-25", totalPrice: 90,
               status: .pending, instrumentName: "Fender Stratocaster", instrumentEmoji: "🎸"),
        Rental(id: "r4", instrumentId: "3", renterId: "u4", hostId: "me",
               startDate: "2025-07-01", endDate: "2025-07-03", totalPrice: 70,
               status: .pending, instrumentName: "Pearl Drum Kit", instrumentEmoji: "🥁"),
    ]
    @State private var selectedTab = 0

    var pending:   [Rental] { bookings.filter { $0.status == .pending } }
    var confirmed: [Rental] { bookings.filter { $0.status == .confirmed || $0.status == .active } }
    var past:      [Rental] { bookings.filter { $0.status == .completed || $0.status == .cancelled } }

    var currentList: [Rental] {
        switch selectedTab {
        case 0: return pending
        case 1: return confirmed
        default: return past
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F0E8").ignoresSafeArea()

                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Bookings")
                                .font(.system(size: 28, weight: .black, design: .serif))
                            Text("Manage rental requests")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(Color(hex: "8C8375"))
                        }
                        Spacer()
                        if pending.count > 0 {
                            ZStack {
                                Circle().fill(Color(hex: "C4451A")).frame(width: 28, height: 28)
                                Text("\(pending.count)")
                                    .font(.system(size: 13, weight: .bold))
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .padding()

                    // Tab bar
                    HStack(spacing: 0) {
                        tabBtn("Pending (\(pending.count))",   index: 0)
                        tabBtn("Active (\(confirmed.count))",  index: 1)
                        tabBtn("Past (\(past.count))",         index: 2)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 12)

                    if currentList.isEmpty {
                        Spacer()
                        Text("No bookings here yet")
                            .font(.system(size: 16))
                            .foregroundColor(Color(hex: "8C8375"))
                        Spacer()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(currentList) { booking in
                                    HostBookingCard(rental: booking,
                                                    onApprove: { updateStatus(id: booking.id, status: .confirmed) },
                                                    onDecline: { updateStatus(id: booking.id, status: .cancelled) })
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

    private func updateStatus(id: String, status: Rental.RentalStatus) {
        if let idx = bookings.firstIndex(where: { $0.id == id }) {
            bookings[idx] = Rental(
                id: bookings[idx].id, instrumentId: bookings[idx].instrumentId,
                renterId: bookings[idx].renterId, hostId: bookings[idx].hostId,
                startDate: bookings[idx].startDate, endDate: bookings[idx].endDate,
                totalPrice: bookings[idx].totalPrice, status: status,
                instrumentName: bookings[idx].instrumentName, instrumentEmoji: bookings[idx].instrumentEmoji)
        }
    }

    private func tabBtn(_ label: String, index: Int) -> some View {
        Button { selectedTab = index } label: {
            Text(label)
                .font(.system(size: 11, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 9)
                .background(selectedTab == index ? Color(hex: "0D0D0D") : Color.clear)
                .foregroundColor(selectedTab == index ? Color(hex: "F5F0E8") : Color(hex: "8C8375"))
                .cornerRadius(7)
        }
        .padding(3)
        .background(Color(hex: "E8E0D0"))
        .cornerRadius(9)
    }
}

// ── Host Booking Card ─────────────────────────
struct HostBookingCard: View {
    let rental: Rental
    let onApprove: () -> Void
    let onDecline: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(rental.instrumentEmoji).font(.system(size: 30))
                VStack(alignment: .leading, spacing: 3) {
                    Text(rental.instrumentName)
                        .font(.system(size: 15, weight: .bold))
                    Text("Renter: User \(rental.renterId.prefix(6))")
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8C8375"))
                }
                Spacer()
                Text("$\(Int(rental.totalPrice))")
                    .font(.system(size: 18, weight: .black))
                    .foregroundColor(Color(hex: "C4451A"))
            }

            HStack(spacing: 6) {
                Image(systemName: "calendar")
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "8C8375"))
                Text("\(rental.startDate) → \(rental.endDate)")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "8C8375"))
                Spacer()
                Text("\(rental.daysCount) days")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "4A4A4A"))
            }

            if rental.status == .pending {
                HStack(spacing: 10) {
                    Button(action: onDecline) {
                        Text("Decline")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(hex: "F0EBE0"))
                            .foregroundColor(Color(hex: "8C8375"))
                            .cornerRadius(8)
                    }
                    Button(action: onApprove) {
                        Text("Approve ✓")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color(hex: "5A7A5C"))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
            } else {
                let color: Color = rental.status == .confirmed || rental.status == .active
                    ? Color(hex: "5A7A5C") : Color(hex: "8C8375")
                Text(rental.status.rawValue.capitalized)
                    .font(.system(size: 12, weight: .semibold))
                    .padding(.horizontal, 10).padding(.vertical, 5)
                    .background(color.opacity(0.12))
                    .foregroundColor(color)
                    .cornerRadius(6)
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}
