import XCTest
@testable import WongSmileClub

final class PointsBalanceTests: XCTestCase {
    func testBalancesSeparatePending() {
        let approvedEarn = PointsTransaction(type: .earn, status: .approved, source: .feedback, points: 150)
        let pendingEarn = PointsTransaction(type: .earn, status: .pending, source: .referral, points: 200)
        let redeem = PointsTransaction(type: .redeem, status: .approved, source: .rewardRedemption, points: 50)

        let balances = PointsSummary.balances(from: [approvedEarn, pendingEarn, redeem])

        XCTAssertEqual(approvedEarn.points, 150)
        XCTAssertEqual(redeem.points, -50)
        XCTAssertEqual(balances.available, 100)
        XCTAssertEqual(balances.pending, 200)
    }
}
