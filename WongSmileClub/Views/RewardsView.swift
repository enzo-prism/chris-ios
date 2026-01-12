import SwiftUI
import SwiftData

struct RewardsView: View {
    @EnvironmentObject private var dataStore: AppDataStore
    @Query(sort: \PointsTransaction.date, order: .reverse) private var transactions: [PointsTransaction]

    private var balance: Int {
        PointsSummary.balance(from: transactions)
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    SectionHeader(title: "Rewards")

                    Text("Available points: \(balance)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    ForEach(dataStore.rewards) { reward in
                        NavigationLink {
                            RewardDetailView(reward: reward, balance: balance)
                        } label: {
                            RewardCardView(reward: reward, balance: balance)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Rewards")
    }
}
