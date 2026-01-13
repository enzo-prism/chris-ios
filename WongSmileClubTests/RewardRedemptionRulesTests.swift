import XCTest
@testable import WongSmileClub

final class RewardRedemptionRulesTests: XCTestCase {
    func testCanRedeemWhenBalanceSufficient() {
        let reward = Reward(
            id: "reward-1",
            title: "Test Reward",
            description: "",
            pointsCost: 500,
            finePrint: "",
            category: "Test",
            active: true
        )

        XCTAssertFalse(RewardRedemptionRules.canRedeem(reward: reward, balance: 200))
        XCTAssertTrue(RewardRedemptionRules.canRedeem(reward: reward, balance: 500))
        XCTAssertTrue(RewardRedemptionRules.canRedeem(reward: reward, balance: 750))
    }

    func testInactiveRewardCannotBeRedeemed() {
        let reward = Reward(
            id: "reward-2",
            title: "Inactive Reward",
            description: "",
            pointsCost: 100,
            finePrint: "",
            category: "Test",
            active: false
        )

        XCTAssertFalse(RewardRedemptionRules.canRedeem(reward: reward, balance: 1000))
    }

    func testPendingPointsDoNotEnableRedemption() {
        let reward = Reward(
            id: "reward-3",
            title: "Pending Reward",
            description: "",
            pointsCost: 300,
            finePrint: "",
            category: "Test",
            active: true
        )

        let canRedeem = RewardRedemptionRules.canRedeem(reward: reward, balance: 100)

        XCTAssertFalse(canRedeem)
    }
}
