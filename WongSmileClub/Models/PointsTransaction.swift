import Foundation
import SwiftData

@Model
final class PointsTransaction {
    enum TransactionType: String, Codable {
        case earn
        case redeem
    }

    enum PointsStatus: String, Codable {
        case pending
        case approved
        case declined
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
    var status: PointsStatus
    var source: Source
    var points: Int
    var note: String
    var metadataJSON: String?

    init(
        id: UUID = UUID(),
        date: Date = Date(),
        type: TransactionType,
        status: PointsStatus = .approved,
        source: Source,
        points: Int,
        note: String = "",
        metadataJSON: String? = nil
    ) {
        self.id = id
        self.date = date
        self.type = type
        self.status = status
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
    static func availableBalance(from transactions: [PointsTransaction]) -> Int {
        transactions
            .filter { $0.status == .approved || $0.type == .redeem }
            .reduce(0) { $0 + $1.points }
    }

    static func pendingBalance(from transactions: [PointsTransaction]) -> Int {
        transactions
            .filter { $0.status == .pending && $0.type == .earn }
            .reduce(0) { $0 + $1.points }
    }

    static func balances(from transactions: [PointsTransaction]) -> (available: Int, pending: Int) {
        (availableBalance(from: transactions), pendingBalance(from: transactions))
    }
}
