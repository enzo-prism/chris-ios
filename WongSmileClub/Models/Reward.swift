import Foundation

struct Reward: Identifiable, Codable {
    let id: String
    let title: String
    let description: String
    let pointsCost: Int
    let finePrint: String
    let category: String
    let active: Bool
}

struct RewardRedemptionRules {
    static func canRedeem(reward: Reward, balance: Int) -> Bool {
        reward.active && balance >= reward.pointsCost
    }
}
