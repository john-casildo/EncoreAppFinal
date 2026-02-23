import Foundation

// ─────────────────────────────────────────────
// SUPABASE CONFIG
// 1. Go to https://supabase.com → New Project
// 2. Settings → API → copy URL and anon key
// 3. Paste them below
// ─────────────────────────────────────────────
struct SupabaseConfig {
    static let url = "https://oxqawqbomhciqmstzoos.supabase.co"
    static let anonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im94cWF3cWJvbWhjaXFtc3R6b29zIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE4NDE4NzksImV4cCI6MjA4NzQxNzg3OX0.1bom887ZH5zGE2eVtPoOzXyFYHwilcMnbM0Tj32tyU0"
}

// Simple HTTP client for Supabase REST API
class SupabaseClient {
    static let shared = SupabaseClient()
    private var authToken: String?

    private init() {}

    func setToken(_ token: String?) {
        self.authToken = token
    }

    // Generic GET from a table
    func fetch<T: Decodable>(
        table: String,
        query: String = "",
        completion: @escaping (Result<[T], Error>) -> Void
    ) {
        var urlString = "\(SupabaseConfig.url)/rest/v1/\(table)"
        if !query.isEmpty { urlString += "?\(query)" }

        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            guard let data = data else { return }
            do {
                let decoded = try JSONDecoder().decode([T].self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // POST to a table
    func insert<T: Encodable>(
        table: String,
        body: T,
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: "\(SupabaseConfig.url)/rest/v1/\(table)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("return=representation", forHTTPHeaderField: "Prefer")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            completion(.success(data ?? Data()))
        }.resume()
    }

    // PATCH (update) a row
    func update(
        table: String,
        id: String,
        body: [String: Any],
        completion: @escaping (Result<Data, Error>) -> Void
    ) {
        guard let url = URL(string: "\(SupabaseConfig.url)/rest/v1/\(table)?id=eq.\(id)") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = authToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error { completion(.failure(error)); return }
            completion(.success(data ?? Data()))
        }.resume()
    }
}
