import Foundation

struct Offer: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let recommendation: String
    let partner: String
    let url: String
    let promoCode: String
    let startDate: Date
    let endDate: Date
    let imageName: String?

    var isExpired: Bool {
        endDate < Date()
    }

    var endDateText: String {
        DateFormatter.offerDateFormatter.string(from: endDate)
    }

    var urlValue: URL? {
        URL(string: url)
    }
}

extension DateFormatter {
    static let offerDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
