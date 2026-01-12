import SwiftUI

struct RewardCardView: View {
    let reward: Reward
    let balance: Int

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(reward.title)
                        .font(.system(.headline, design: .rounded))
                    Spacer()
                    PointsPill(points: reward.pointsCost)
                }

                Text(reward.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if !RewardRedemptionRules.canRedeem(reward: reward, balance: balance) {
                    Text("Need \(reward.pointsCost - balance) more points")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
