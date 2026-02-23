import SwiftUI

struct HostListingsView: View {
    @State private var listings = Instrument.samples
    @State private var showAddSheet = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F0E8").ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("My Listings")
                                .font(.system(size: 28, weight: .black, design: .serif))
                            Text("\(listings.count) instruments listed")
                                .font(.system(size: 13, weight: .light))
                                .foregroundColor(Color(hex: "8C8375"))
                        }
                        Spacer()
                        Button { showAddSheet = true } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 38, height: 38)
                                .background(Color(hex: "C4451A"))
                                .cornerRadius(10)
                        }
                    }
                    .padding()

                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(listings) { listing in
                                HostListingCard(instrument: listing) {
                                    // Toggle availability
                                    if let idx = listings.firstIndex(where: { $0.id == listing.id }) {
                                        listings[idx] = Instrument(
                                            id: listing.id, hostId: listing.hostId, name: listing.name,
                                            category: listing.category, description: listing.description,
                                            pricePerDay: listing.pricePerDay, imageEmoji: listing.imageEmoji,
                                            location: listing.location, isAvailable: !listing.isAvailable,
                                            rating: listing.rating, reviewCount: listing.reviewCount)
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showAddSheet) {
                AddInstrumentView { newInstrument in
                    listings.insert(newInstrument, at: 0)
                }
            }
        }
    }
}

// ── Host Listing Card ─────────────────────────
struct HostListingCard: View {
    let instrument: Instrument
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(hex: "EDE5D5"))
                    .frame(width: 64, height: 64)
                Text(instrument.imageEmoji).font(.system(size: 32))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(instrument.name)
                    .font(.system(size: 15, weight: .bold))
                HStack(spacing: 8) {
                    Text(instrument.category)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8C8375"))
                    Text("·")
                        .foregroundColor(Color(hex: "8C8375"))
                    Text(instrument.location)
                        .font(.system(size: 12))
                        .foregroundColor(Color(hex: "8C8375"))
                }
                Text("$\(Int(instrument.pricePerDay))/day · ★ \(String(format: "%.1f", instrument.rating))")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(Color(hex: "C4451A"))
            }

            Spacer()

            VStack(spacing: 8) {
                Toggle("", isOn: Binding(get: { instrument.isAvailable }, set: { _ in onToggle() }))
                    .tint(Color(hex: "5A7A5C"))
                    .labelsHidden()
                    .scaleEffect(0.8)
                Text(instrument.isAvailable ? "Active" : "Hidden")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(instrument.isAvailable ? Color(hex: "5A7A5C") : Color(hex: "8C8375"))
            }
        }
        .padding(14)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 2)
    }
}

// ── Add Instrument Sheet ──────────────────────
struct AddInstrumentView: View {
    let onSave: (Instrument) -> Void
    @Environment(\.dismiss) var dismiss

    @State private var form = NewInstrument()
    @State private var isSaving = false
    @State private var showEmojiPicker = false

    var body: some View {
        NavigationView {
            ZStack {
                Color(hex: "F5F0E8").ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 20) {
                        // Emoji picker
                        Button { showEmojiPicker.toggle() } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: "EDE5D5"))
                                    .frame(width: 100, height: 100)
                                Text(form.imageEmoji).font(.system(size: 56))
                                Image(systemName: "pencil.circle.fill")
                                    .foregroundColor(Color(hex: "C4451A"))
                                    .background(Color.white.clipShape(Circle()))
                                    .offset(x: 36, y: 36)
                            }
                        }
                        .padding(.top)

                        if showEmojiPicker {
                            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 12) {
                                ForEach(NewInstrument.emojiOptions, id: \.self) { emoji in
                                    Button {
                                        form.imageEmoji = emoji
                                        showEmojiPicker = false
                                    } label: {
                                        Text(emoji).font(.system(size: 32))
                                            .frame(width: 52, height: 52)
                                            .background(form.imageEmoji == emoji
                                                        ? Color(hex: "C4451A").opacity(0.15)
                                                        : Color(hex: "EDE5D5"))
                                            .cornerRadius(10)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }

                        Group {
                            formField(label: "Instrument Name") {
                                TextField("e.g. Fender Stratocaster", text: $form.name)
                            }

                            formField(label: "Category") {
                                Picker("Category", selection: $form.category) {
                                    ForEach(NewInstrument.categories, id: \.self) { Text($0) }
                                }
                                .pickerStyle(.menu)
                                .foregroundColor(Color(hex: "C4451A"))
                            }

                            formField(label: "Price per Day ($)") {
                                TextField("e.g. 25", text: $form.pricePerDay)
                                    .keyboardType(.decimalPad)
                            }

                            formField(label: "Location") {
                                TextField("e.g. San José", text: $form.location)
                            }

                            formField(label: "Description") {
                                TextEditor(text: $form.description)
                                    .frame(minHeight: 80)
                            }
                        }
                        .padding(.horizontal)

                        Button(action: saveInstrument) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12).fill(Color(hex: "C4451A")).frame(height: 52)
                                if isSaving {
                                    ProgressView().tint(.white)
                                } else {
                                    Text("List Instrument")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
            }
            .navigationTitle("List an Instrument")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }.foregroundColor(Color(hex: "C4451A"))
                }
            }
        }
    }

    private func formField<Content: View>(label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label).font(.system(size: 12, weight: .semibold)).foregroundColor(Color(hex: "8C8375")).tracking(0.5)
            content()
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "E0D8C8"), lineWidth: 1))
        }
    }

    private func saveInstrument() {
        isSaving = true
        let newInstrument = Instrument(
            id: UUID().uuidString,
            hostId: "current_host",
            name: form.name.isEmpty ? "Unnamed Instrument" : form.name,
            category: form.category,
            description: form.description,
            pricePerDay: Double(form.pricePerDay) ?? 10,
            imageEmoji: form.imageEmoji,
            location: form.location.isEmpty ? "Unknown" : form.location,
            isAvailable: true,
            rating: 0, reviewCount: 0
        )
        // In production: POST to Supabase here
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isSaving = false
            onSave(newInstrument)
            dismiss()
        }
    }
}
