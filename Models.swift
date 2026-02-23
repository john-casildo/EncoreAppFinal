import Foundation

// ── User ────────────────────────────────────
struct AppUser: Codable, Identifiable {
    let id: String
    var name: String
    var email: String
    var role: String          // "renter" or "host"
    var avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case id, name, email, role
        case avatarUrl = "avatar_url"
    }
}

// ── Instrument ──────────────────────────────
struct Instrument: Codable, Identifiable {
    let id: String
    var hostId: String
    var name: String
    var category: String
    var description: String
    var pricePerDay: Double
    var imageEmoji: String    // using emoji for now; replace with imageUrl later
    var location: String
    var isAvailable: Bool
    var rating: Double
    var reviewCount: Int

    enum CodingKeys: String, CodingKey {
        case id, name, category, description, location, rating
        case hostId       = "host_id"
        case pricePerDay  = "price_per_day"
        case imageEmoji   = "image_emoji"
        case isAvailable  = "is_available"
        case reviewCount  = "review_count"
    }

    // Sample data for previews / offline mode
    static let samples: [Instrument] = [
        Instrument(id: "1", hostId: "h1", name: "Fender Stratocaster", category: "Guitar",
                   description: "American Professional II in sunburst. Rosewood fretboard, perfect condition.",
                   pricePerDay: 18, imageEmoji: "🎸", location: "San José", isAvailable: true, rating: 4.9, reviewCount: 47),
        Instrument(id: "2", hostId: "h2", name: "Yamaha P-125 Piano", category: "Piano",
                   description: "88-key weighted digital piano. Includes sustain pedal and stand.",
                   pricePerDay: 25, imageEmoji: "🎹", location: "Heredia", isAvailable: true, rating: 4.8, reviewCount: 31),
        Instrument(id: "3", hostId: "h3", name: "Pearl Export Drum Kit", category: "Drums",
                   description: "Full 5-piece kit with cymbals, hardware and throne.",
                   pricePerDay: 35, imageEmoji: "🥁", location: "Alajuela", isAvailable: true, rating: 4.7, reviewCount: 22),
        Instrument(id: "4", hostId: "h4", name: "Yamaha Alto Saxophone", category: "Brass",
                   description: "YAS-280. Comes with mouthpiece, ligature and hard case.",
                   pricePerDay: 22, imageEmoji: "🎷", location: "San José", isAvailable: true, rating: 4.8, reviewCount: 29),
        Instrument(id: "5", hostId: "h5", name: "Stentor Violin 4/4", category: "Strings",
                   description: "Full-size violin with bow, rosin and case.",
                   pricePerDay: 14, imageEmoji: "🎻", location: "Cartago", isAvailable: true, rating: 4.9, reviewCount: 56),
        Instrument(id: "6", hostId: "h6", name: "Roland TD-17 E-Drums", category: "Drums",
                   description: "Professional V-Drums. Mesh heads, Bluetooth, totally silent.",
                   pricePerDay: 42, imageEmoji: "🥁", location: "San José", isAvailable: false, rating: 4.9, reviewCount: 14),
    ]
}

// ── Rental ──────────────────────────────────
struct Rental: Codable, Identifiable {
    let id: String
    var instrumentId: String
    var renterId: String
    var hostId: String
    var startDate: String     // ISO date string "2025-06-01"
    var endDate: String
    var totalPrice: Double
    var status: RentalStatus
    var instrumentName: String
    var instrumentEmoji: String

    enum RentalStatus: String, Codable {
        case pending   = "pending"
        case confirmed = "confirmed"
        case active    = "active"
        case completed = "completed"
        case cancelled = "cancelled"
    }

    enum CodingKeys: String, CodingKey {
        case id, status
        case instrumentId    = "instrument_id"
        case renterId        = "renter_id"
        case hostId          = "host_id"
        case startDate       = "start_date"
        case endDate         = "end_date"
        case totalPrice      = "total_price"
        case instrumentName  = "instrument_name"
        case instrumentEmoji = "instrument_emoji"
    }

    var daysCount: Int {
        let fmt = DateFormatter(); fmt.dateFormat = "yyyy-MM-dd"
        guard let s = fmt.date(from: startDate), let e = fmt.date(from: endDate) else { return 1 }
        return max(1, Calendar.current.dateComponents([.day], from: s, to: e).day ?? 1)
    }

    static let samples: [Rental] = [
        Rental(id: "r1", instrumentId: "1", renterId: "me", hostId: "h1",
               startDate: "2025-06-10", endDate: "2025-06-14", totalPrice: 72,
               status: .active, instrumentName: "Fender Stratocaster", instrumentEmoji: "🎸"),
        Rental(id: "r2", instrumentId: "2", renterId: "me", hostId: "h2",
               startDate: "2025-05-01", endDate: "2025-05-03", totalPrice: 50,
               status: .completed, instrumentName: "Yamaha P-125", instrumentEmoji: "🎹"),
    ]
}

// ── Review ──────────────────────────────────
struct Review: Codable, Identifiable {
    let id: String
    var rentalId: String
    var rating: Int
    var comment: String
    var reviewerName: String

    enum CodingKeys: String, CodingKey {
        case id, rating, comment
        case rentalId     = "rental_id"
        case reviewerName = "reviewer_name"
    }
}

// ── New Instrument form model ────────────────
struct NewInstrument {
    var name: String = ""
    var category: String = "Guitar"
    var description: String = ""
    var pricePerDay: String = ""
    var location: String = ""
    var imageEmoji: String = "🎸"

    static let categories = ["Guitar", "Piano", "Drums", "Bass", "Strings", "Brass", "DJ / Electronic", "Other"]
    static let emojiOptions = ["🎸","🎹","🥁","🎷","🎻","🎺","🪕","🎵","🎧","🪗"]
}
