import XCTest
@testable import WongSmileClub

final class PointsBalanceTests: XCTestCase {
    func testBalanceUsesSignedPoints() {
        let earn = PointsTransaction(type: .earn, source: .feedback, points: 150)
        let redeem = PointsTransaction(type: .redeem, source: .rewardRedemption, points: 50)

        let balance = PointsSummary.balance(from: [earn, redeem])

        XCTAssertEqual(earn.points, 150)
        XCTAssertEqual(redeem.points, -50)
        XCTAssertEqual(balance, 100)
    }
}
