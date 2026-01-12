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
}
