import XCTest
@testable import WongSmileClub

final class CareDataTests: XCTestCase {
    func testSpecialistsDecode() {
        let specialists = BundleDataService.loadSpecialists()
        XCTAssertFalse(specialists.isEmpty)
        XCTAssertFalse(specialists.first?.category.isEmpty ?? true)
    }

    func testEducationTopicsDecode() {
        let topics = BundleDataService.loadEducationTopics()
        XCTAssertFalse(topics.isEmpty)
        XCTAssertFalse(topics.first?.title.isEmpty ?? true)
    }

    func testReviewClaimPolicyDisabledReturnsNil() {
        let transaction = ReviewRewardPolicy.transactionForClaim(platform: .google, enabled: false)
        XCTAssertNil(transaction)
    }

    func testReviewClaimPolicyEnabledCreatesTransaction() {
        let transaction = ReviewRewardPolicy.transactionForClaim(platform: .yelp, enabled: true)
        XCTAssertNotNil(transaction)
        XCTAssertEqual(transaction?.source, .publicReviewYelp)
        XCTAssertEqual(transaction?.points, PointsValues.publicReview)
        XCTAssertEqual(transaction?.status, .pending)
    }
}
