import SwiftUI
import SwiftData

struct RewardDetailView: View {
    let reward: Reward
    let availableBalance: Int
    let pendingBalance: Int
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @Environment(\.modelContext) private var modelContext

    private var pointsStore: PointsStore {
        PointsStore(context: modelContext)
    }

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(reward.title)
                            .font(.system(.title2, design: .rounded).weight(.bold))
                        Text(reward.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Cost: \(reward.pointsCost) points")
                            .font(.headline)
                        Text(reward.finePrint)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                NavigationLink {
                    RewardRedemptionView(
                        reward: reward,
                        currentBalance: availableBalance,
                        config: config,
                        formspree: formspree,
                        pointsStore: pointsStore
                    )
                } label: {
                    PrimaryButtonLabel(title: "Redeem Reward", systemImage: AppSymbol.rewards)
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(!RewardRedemptionRules.canRedeem(reward: reward, balance: availableBalance))

                if availableBalance + pendingBalance >= reward.pointsCost, !RewardRedemptionRules.canRedeem(reward: reward, balance: availableBalance) {
                    Text("You have pending points that aren’t available yet.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
        }
        .navigationTitle("Reward")
    }
}
