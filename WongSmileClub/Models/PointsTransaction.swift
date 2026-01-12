import Foundation
import SwiftData

@Model
final class PointsTransaction {
    enum TransactionType: String, Codable {
        case earn
        case redeem
    }

    enum Source: String, Codable {
        case referral
        case photo
        case video
        case instagram
        case feedback
        case appointment
        case rewardRedemption
        case publicReviewGoogle
        case publicReviewYelp
        case other
    }

    var id: UUID
    var date: Date
    var type: TransactionType
    var source: Source
    var points: Int
    var note: String
    var metadataJSON: String?

    init(id: UUID = UUID(), date: Date = Date(), type: TransactionType, source: Source, points: Int, note: String = "", metadataJSON: String? = nil) {
        self.id = id
        self.date = date
        self.type = type
        self.source = source
        self.points = PointsTransaction.signedPoints(points, for: type)
        self.note = note
        self.metadataJSON = metadataJSON
    }

    var displayPoints: String {
        let value = abs(points)
        return type == .redeem ? "-\(value)" : "+\(value)"
    }

    static func signedPoints(_ points: Int, for type: TransactionType) -> Int {
        let value = abs(points)
        return type == .redeem ? -value : value
    }

    static func metadata(from values: [String: String]) -> String? {
        guard !values.isEmpty,
              let data = try? JSONSerialization.data(withJSONObject: values, options: [])
        else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
}

struct PointsSummary {
    static func balance(from transactions: [PointsTransaction]) -> Int {
        transactions.reduce(0) { $0 + $1.points }
    }
}
