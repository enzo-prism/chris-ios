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
    let tags: [String]
    let imageName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case recommendation
        case partner
        case url
        case promoCode
        case startDate
        case endDate
        case tags
        case imageName
    }

    init(id: String, title: String, description: String, recommendation: String, partner: String, url: String, promoCode: String, startDate: Date, endDate: Date, tags: [String] = [], imageName: String?) {
        self.id = id
        self.title = title
        self.description = description
        self.recommendation = recommendation
        self.partner = partner
        self.url = url
        self.promoCode = promoCode
        self.startDate = startDate
        self.endDate = endDate
        self.tags = tags
        self.imageName = imageName
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        recommendation = try container.decode(String.self, forKey: .recommendation)
        partner = try container.decode(String.self, forKey: .partner)
        url = try container.decode(String.self, forKey: .url)
        promoCode = try container.decode(String.self, forKey: .promoCode)
        startDate = try container.decode(Date.self, forKey: .startDate)
        endDate = try container.decode(Date.self, forKey: .endDate)
        tags = try container.decodeIfPresent([String].self, forKey: .tags) ?? []
        imageName = try container.decodeIfPresent(String.self, forKey: .imageName)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        try container.encode(recommendation, forKey: .recommendation)
        try container.encode(partner, forKey: .partner)
        try container.encode(url, forKey: .url)
        try container.encode(promoCode, forKey: .promoCode)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
        try container.encode(tags, forKey: .tags)
        try container.encodeIfPresent(imageName, forKey: .imageName)
    }

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
