import SwiftUI
import SwiftData

struct PointsProgressCard: View {
    @EnvironmentObject private var dataStore: AppDataStore
    @Query(sort: \PointsTransaction.date, order: .reverse) private var transactions: [PointsTransaction]

    var body: some View {
        let balances = PointsSummary.balances(from: transactions)
        let nextReward = dataStore.rewards
            .filter { $0.pointsCost > balances.available }
            .sorted { $0.pointsCost < $1.pointsCost }
            .first
        let progressTotal = max(nextReward?.pointsCost ?? 1, 1)
        let progressValue = min(balances.available, progressTotal)

        return GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Available Points")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(balances.available)")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    }
                    Spacer()
                    PointsPill(points: balances.available)
                }

                if balances.pending > 0 {
                    Text("Pending points: \(balances.pending)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let nextReward = nextReward {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Next reward: \(nextReward.title)")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                        ProgressView(value: Double(progressValue), total: Double(progressTotal))
                            .tint(.accentColor)
                    }
                } else {
                    Text("You have enough points to redeem a reward.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
