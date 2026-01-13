import Foundation

struct Specialist: Identifiable, Codable {
    let id: String
    let category: String
    let name: String
    let practiceName: String
    let phone: String
    let address: String
    let websiteURL: String
    let mapQuery: String
    let whyRecommended: String
    let tags: [String]

    var websiteLink: URL? {
        URL(string: websiteURL)
    }

    var phoneURL: URL? {
        guard !phone.hasPrefix("TODO") else { return nil }
        let digits = phone.filter { "0123456789".contains($0) }
        return digits.isEmpty ? nil : URL(string: "tel://\(digits)")
    }

    var mapsURL: URL? {
        let encoded = mapQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return encoded.isEmpty ? nil : URL(string: "http://maps.apple.com/?q=\(encoded)")
    }
}
