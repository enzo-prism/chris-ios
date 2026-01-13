import Foundation

enum ReviewPlatform {
    case google
    case yelp

    var source: PointsTransaction.Source {
        switch self {
        case .google: return .publicReviewGoogle
        case .yelp: return .publicReviewYelp
        }
    }

    var note: String {
        switch self {
        case .google: return "Public review (Google)"
        case .yelp: return "Public review (Yelp)"
        }
    }
}

struct ReviewRewardPolicy {
    static func transactionForClaim(platform: ReviewPlatform, enabled: Bool) -> PointsTransaction? {
        guard enabled else { return nil }
        return PointsTransaction(
            type: .earn,
            status: .pending,
            source: platform.source,
            points: PointsValues.publicReview,
            note: platform.note
        )
    }
}
