import SwiftUI

struct RewardCardView: View {
    let reward: Reward
    let balance: Int

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

                if !RewardRedemptionRules.canRedeem(reward: reward, balance: balance) {
                    Text("Need \(reward.pointsCost - balance) more points")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
