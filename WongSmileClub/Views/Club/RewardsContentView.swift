import SwiftUI
import SwiftData

struct RewardsContentView: View {
    @EnvironmentObject private var dataStore: AppDataStore
    @Query(sort: \PointsTransaction.date, order: .reverse) private var transactions: [PointsTransaction]

    var body: some View {
        let balances = PointsSummary.balances(from: transactions)

        VStack(spacing: 16) {
            SectionHeader(title: "Rewards", systemImage: AppSymbol.rewards)

            Text("Available points: \(balances.available)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let lastUpdated = dataStore.rewardsLastUpdated {
                Text("Last updated \(DateFormatter.shortDateTime.string(from: lastUpdated))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            if balances.pending > 0 {
                Text("Pending points: \(balances.pending) (reviewed before redeeming)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            ForEach(dataStore.rewards) { reward in
                NavigationLink {
                    RewardDetailView(
                        reward: reward,
                        availableBalance: balances.available,
                        pendingBalance: balances.pending
                    )
                } label: {
                    RewardCardView(reward: reward, availableBalance: balances.available, pendingBalance: balances.pending)
                }
                .buttonStyle(.plain)
            }
        }
    }
}
