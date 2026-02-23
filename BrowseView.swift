import SwiftUI

struct BrowseView: View {
    @State private var searchText = ""
    @State private var selectedCategory = "All"
    @State private var instruments = Instrument.samples
    @State private var selectedInstrument: Instrument?

    let categories = ["All", "Guitar", "Piano", "Drums", "Brass", "Strings", "DJ / Electronic"]

    var filtered: [Instrument] {
        instruments.filter { i in
            let matchCat = selectedCategory == "All" || i.category == selectedCategory
            let matchSearch = searchText.isEmpty || i.name.localizedCaseInsensitiveContains(searchText) ||
                              i.category.localizedCaseInsensitiveContains(searchText)
            return matchCat && matchSearch
        }
    }

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F0E8").ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {

                        // Header
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Find your")
                                .font(.system(size: 32, weight: .light, design: .serif))
                                .foregroundColor(Color(hex: "0D0D0D"))
                            Text("next instrument")
                                .font(.system(size: 32, weight: .black, design: .serif))
                                .italic()
                                .foregroundColor(Color(hex: "C4451A"))
                        }
                        .padding(.horizontal)
                        .padding(.top, 8)

                        // Search bar
                        HStack {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(Color(hex: "8C8375"))
                            TextField("Search guitars, pianos, drums…", text: $searchText)
                                .font(.system(size: 15))
                        }
                        .padding(14)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
                        .padding(.horizontal)

                        // Category chips
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(categories, id: \.self) { cat in
                                    CategoryChip(label: cat, isSelected: selectedCategory == cat) {
                                        selectedCategory = cat
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        // Results count
                        Text("\(filtered.count) instruments available")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(Color(hex: "8C8375"))
                            .padding(.horizontal)

                        // Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            ForEach(filtered) { instrument in
                                InstrumentCard(instrument: instrument)
                                    .onTapGesture { selectedInstrument = instrument }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(item: $selectedInstrument) { inst in
                InstrumentDetailView(instrument: inst)
            }
        }
    }
}

// ── Category Chip ────────────────────────────
struct CategoryChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.system(size: 13, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color(hex: "0D0D0D") : Color.white)
                .foregroundColor(isSelected ? Color(hex: "F5F0E8") : Color(hex: "0D0D0D"))
                .cornerRadius(20)
                .overlay(RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(hex: isSelected ? "0D0D0D" : "D0C8B8"), lineWidth: 1))
        }
    }
}

// ── Instrument Card ──────────────────────────
struct InstrumentCard: View {
    let instrument: Instrument

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image area
            ZStack {
                LinearGradient(colors: [Color(hex: "EDE5D5"), Color(hex: "E0D8C8")],
                               startPoint: .topLeading, endPoint: .bottomTrailing)
                Text(instrument.imageEmoji)
                    .font(.system(size: 52))
                if !instrument.isAvailable {
                    Color.black.opacity(0.35).cornerRadius(12)
                    Text("Unavailable")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.black.opacity(0.6))
                        .cornerRadius(6)
                }
            }
            .frame(height: 130)
            .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(instrument.name)
                    .font(.system(size: 14, weight: .bold))
                    .lineLimit(1)
                Text(instrument.category)
                    .font(.system(size: 11))
                    .foregroundColor(Color(hex: "8C8375"))
                HStack {
                    Text("★ \(String(format: "%.1f", instrument.rating))")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color(hex: "E8A838"))
                    Text("(\(instrument.reviewCount))")
                        .font(.system(size: 11))
                        .foregroundColor(Color(hex: "8C8375"))
                    Spacer()
                    Text("$\(Int(instrument.pricePerDay))/day")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(hex: "C4451A"))
                }
            }
            .padding(10)
        }
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}
