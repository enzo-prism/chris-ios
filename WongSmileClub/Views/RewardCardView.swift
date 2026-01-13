import SwiftUI

struct RewardCardView: View {
    let reward: Reward
    let availableBalance: Int
    let pendingBalance: Int

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .top, spacing: 12) {
                    IconBadge(systemImage: AppSymbol.rewards)

                    VStack(alignment: .leading, spacing: 6) {
                        Text(reward.title)
                            .font(.system(.headline, design: .rounded))
                        Text(reward.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()
                    PointsPill(points: reward.pointsCost)
                }

                if !RewardRedemptionRules.canRedeem(reward: reward, balance: availableBalance) {
                    if availableBalance + pendingBalance >= reward.pointsCost, pendingBalance > 0 {
                        Text("You have pending points that aren’t available yet.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Need \(max(reward.pointsCost - availableBalance, 0)) more points")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
