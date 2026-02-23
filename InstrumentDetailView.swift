import SwiftUI

struct InstrumentDetailView: View {
    let instrument: Instrument
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var authManager: AuthManager

    @State private var startDate = Date()
    @State private var endDate   = Date().addingTimeInterval(86400 * 3)
    @State private var showConfirmation = false
    @State private var isBooking = false

    var days: Int { max(1, Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 1) }
    var total: Double { Double(days) * instrument.pricePerDay }

    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Color(hex: "F5F0E8").ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Hero image
                        ZStack {
                            LinearGradient(colors: [Color(hex: "EDE5D5"), Color(hex: "E0D8C8")],
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                            Text(instrument.imageEmoji).font(.system(size: 100))
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 240)

                        VStack(alignment: .leading, spacing: 16) {

                            // Title + price
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(instrument.name)
                                        .font(.system(size: 26, weight: .black, design: .serif))
                                    Text(instrument.category.uppercased())
                                        .font(.system(size: 11, weight: .semibold))
                                        .foregroundColor(Color(hex: "8C8375"))
                                        .tracking(1.5)
                                }
                                Spacer()
                                VStack(alignment: .trailing) {
                                    Text("$\(Int(instrument.pricePerDay))")
                                        .font(.system(size: 28, weight: .black))
                                        .foregroundColor(Color(hex: "C4451A"))
                                    Text("per day")
                                        .font(.system(size: 12))
                                        .foregroundColor(Color(hex: "8C8375"))
                                }
                            }

                            // Rating + location
                            HStack(spacing: 16) {
                                Label("★ \(String(format: "%.1f", instrument.rating)) (\(instrument.reviewCount) reviews)",
                                      systemImage: "")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "E8A838"))
                                Label(instrument.location, systemImage: "mappin.circle")
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(hex: "8C8375"))
                            }

                            Divider()

                            // Description
                            Text("About this instrument")
                                .font(.system(size: 15, weight: .semibold))
                            Text(instrument.description)
                                .font(.system(size: 14, weight: .light))
                                .foregroundColor(Color(hex: "4A4A4A"))
                                .lineSpacing(4)

                            Divider()

                            // Date picker
                            Text("Select rental dates")
                                .font(.system(size: 15, weight: .semibold))

                            VStack(spacing: 12) {
                                DatePickerRow(label: "Pick up", date: $startDate)
                                DatePickerRow(label: "Return",  date: $endDate)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)

                            // Price breakdown
                            VStack(spacing: 10) {
                                PriceRow(label: "$\(Int(instrument.pricePerDay)) × \(days) day\(days == 1 ? "" : "s")",
                                         value: "$\(Int(total))")
                                PriceRow(label: "Service fee", value: "$\(Int(total * 0.1))")
                                Divider()
                                PriceRow(label: "Total", value: "$\(Int(total * 1.1))", bold: true)
                            }
                            .padding(16)
                            .background(Color.white)
                            .cornerRadius(12)

                        }
                        .padding(.horizontal)
                        .padding(.bottom, 120)
                    }
                }

                // Sticky CTA
                VStack(spacing: 0) {
                    Divider()
                    Button(action: bookNow) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(instrument.isAvailable ? Color(hex: "C4451A") : Color(hex: "8C8375"))
                            if isBooking {
                                ProgressView().tint(.white)
                            } else {
                                Text(instrument.isAvailable ? "Reserve Now" : "Not Available")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(height: 54)
                    }
                    .disabled(!instrument.isAvailable || isBooking)
                    .padding()
                    .background(Color(hex: "F5F0E8"))
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Color(hex: "C4451A"))
                }
            }
            .alert("Reservation Confirmed! 🎸", isPresented: $showConfirmation) {
                Button("Great!") { dismiss() }
            } message: {
                Text("Your rental of \(instrument.name) has been requested. The host will confirm shortly.")
            }
        }
    }

    private func bookNow() {
        isBooking = true
        let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"
        let rental: [String: Any] = [
            "instrument_id":    instrument.id,
            "renter_id":        authManager.currentUser?.id ?? "",
            "host_id":          instrument.hostId,
            "start_date":       fmt.string(from: startDate),
            "end_date":         fmt.string(from: endDate),
            "total_price":      total * 1.1,
            "status":           "pending",
            "instrument_name":  instrument.name,
            "instrument_emoji": instrument.imageEmoji
        ]
        // In production, POST to Supabase here
        // SupabaseClient.shared.insert(table: "rentals", body: rental) { _ in }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            isBooking = false
            showConfirmation = true
        }
    }
}

// ── Sub-components ────────────────────────────
struct DatePickerRow: View {
    let label: String
    @Binding var date: Date

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(Color(hex: "4A4A4A"))
            Spacer()
            DatePicker("", selection: $date, displayedComponents: .date)
                .labelsHidden()
                .accentColor(Color(hex: "C4451A"))
        }
    }
}

struct PriceRow: View {
    let label: String
    let value: String
    var bold = false

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 14, weight: bold ? .bold : .regular))
            Spacer()
            Text(value)
                .font(.system(size: 14, weight: bold ? .bold : .regular))
                .foregroundColor(bold ? Color(hex: "C4451A") : Color(hex: "0D0D0D"))
        }
    }
}
