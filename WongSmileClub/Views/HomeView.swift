import SwiftUI
import SwiftData

struct HomeView: View {
    @EnvironmentObject private var dataStore: AppDataStore
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @Query(sort: \PointsTransaction.date, order: .reverse) private var transactions: [PointsTransaction]
    @Query private var profiles: [UserProfile]

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 20) {
                    heroCard

                    quickActions

                    offersPreview
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("WongSmileClub")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ProfileView()
                } label: {
                    AppIcon(name: AppSymbol.profile, size: AppIconSize.nav, weight: .semibold)
                }
                .accessibilityLabel("Profile")
            }
        }
    }

    private var heroCard: some View {
        let balance = PointsSummary.balance(from: transactions)
        let nextReward = dataStore.rewards
            .filter { $0.pointsCost > balance }
            .sorted { $0.pointsCost < $1.pointsCost }
            .first
        let progressTotal = max(nextReward?.pointsCost ?? 1, 1)
        let progressValue = min(balance, progressTotal)
        let name = profiles.first?.name.isEmpty == false ? profiles.first?.name ?? "" : ""

        return GlassCard {
            VStack(alignment: .leading, spacing: 16) {
                Text(name.isEmpty ? "Welcome" : "Welcome, \(name)")
                    .font(.system(.title2, design: .rounded).weight(.bold))

                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Smile Points")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("\(balance)")
                            .font(.system(.largeTitle, design: .rounded).weight(.bold))
                    }
                    Spacer()
                    PointsPill(points: balance)
                }

                if let nextReward = nextReward {
                    VStack(alignment: .leading, spacing: 8) {
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

                Text(config.practiceName)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var quickActions: some View {
        VStack(spacing: 12) {
            NavigationLink {
                AppointmentRequestView(config: config, formspree: formspree)
            } label: {
                PrimaryButtonLabel(title: "Book Appointment", systemImage: AppSymbol.book)
            }
            .buttonStyle(PrimaryButtonStyle())

            NavigationLink {
                EmergencyView()
            } label: {
                PrimaryButtonLabel(title: "Emergency", systemImage: AppSymbol.emergency)
            }
            .buttonStyle(PrimaryButtonStyle())

            HStack(spacing: 12) {
                NavigationLink {
                    EarnView()
                } label: {
                    PrimaryButtonLabel(title: "Earn Points", systemImage: AppSymbol.earn)
                }
                .buttonStyle(PrimaryButtonStyle())

                NavigationLink {
                    RewardsView()
                } label: {
                    PrimaryButtonLabel(title: "Redeem", systemImage: AppSymbol.rewards)
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
    }

    private var offersPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader(title: "Limited-Time Offers", systemImage: AppSymbol.offers)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(dataStore.offers.prefix(5)) { offer in
                        OfferCardView(offer: offer)
                            .frame(width: 250)
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(AppDataStore())
}
