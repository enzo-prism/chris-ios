import SwiftUI
import SwiftData

struct PointsHistoryView: View {
    @Query(sort: \PointsTransaction.date, order: .reverse) private var transactions: [PointsTransaction]

    var body: some View {
        let balances = PointsSummary.balances(from: transactions)

        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Points History", systemImage: AppSymbol.history)
                            Text("Available points: \(balances.available)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if balances.pending > 0 {
                                Text("Pending points: \(balances.pending)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            ForEach(transactions) { transaction in
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(sourceLabel(for: transaction.source))
                                            .font(.subheadline)
                                        Text(DateFormatter.shortDateTime.string(from: transaction.date))
                                            .font(.caption)
                                            .foregroundStyle(.secondary)

                                        if transaction.status == .pending {
                                            Text("Pending")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        } else if transaction.status == .declined {
                                            Text("Declined")
                                                .font(.caption2)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Spacer()
                                    Text(transaction.displayPoints)
                                        .font(.subheadline)
                                        .foregroundStyle(transaction.type == .redeem ? .secondary : .primary)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Points History")
    }

    private func sourceLabel(for source: PointsTransaction.Source) -> String {
        switch source {
        case .referral: return "Referral"
        case .photo: return "Smile photo"
        case .video: return "Smile video"
        case .instagram: return "Instagram"
        case .feedback: return "Private feedback"
        case .appointment: return "Appointment"
        case .rewardRedemption: return "Reward redemption"
        case .publicReviewGoogle: return "Google review"
        case .publicReviewYelp: return "Yelp review"
        case .other: return "Other"
        }
    }
}
