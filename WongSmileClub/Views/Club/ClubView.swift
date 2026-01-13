import SwiftUI
import SwiftData

struct ClubView: View {
    enum ClubSection: String, CaseIterable, Identifiable {
        case earn = "Earn"
        case rewards = "Rewards"

        var id: String { rawValue }
    }

    @Environment(\.appConfig) private var config
    @EnvironmentObject private var dataStore: AppDataStore
    @Environment(\.modelContext) private var modelContext
    @State private var selectedSection: ClubSection = .earn
    @State private var showSafari = false
    @State private var safariURL: URL?
    @State private var showClaimConfirmation = false
    @State private var claimPlatform: ReviewPlatform = .google

    private var pointsStore: PointsStore {
        PointsStore(context: modelContext)
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    PointsProgressCard()

                    shareExperienceCard

                    Picker("Club section", selection: $selectedSection) {
                        ForEach(ClubSection.allCases) { section in
                            Text(section.rawValue).tag(section)
                        }
                    }
                    .pickerStyle(.segmented)

                    Group {
                        switch selectedSection {
                        case .earn:
                            EarnContentView()
                        case .rewards:
                            RewardsContentView()
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Club")
        .refreshable {
            await dataStore.refreshRewards()
        }
        .sheet(isPresented: $showSafari) {
            if let safariURL {
                SafariView(url: safariURL)
            }
        }
        .confirmationDialog("Claim points for a public review?", isPresented: $showClaimConfirmation, titleVisibility: .visible) {
            Button("Claim points") {
                if let transaction = ReviewRewardPolicy.transactionForClaim(platform: claimPlatform, enabled: config.enablePointsForPublicReviews) {
                    pointsStore.addTransaction(transaction)
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Public reviews are optional. Use at your discretion and follow platform policies.")
        }
    }

    private var shareExperienceCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Share your experience", systemImage: AppSymbol.review)

                Text("Help others discover the practice by leaving a public review.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let googleURL = config.googleReviewURL {
                    Button {
                        safariURL = googleURL
                        showSafari = true
                    } label: {
                        AppLabel(
                            title: "Leave a Google review",
                            systemImage: AppSymbol.review,
                            iconSize: AppIconSize.inline,
                            textFont: .system(.headline, design: .rounded)
                        )
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("Google review link not configured.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                if let yelpURL = config.yelpReviewURL {
                    Button {
                        safariURL = yelpURL
                        showSafari = true
                    } label: {
                        AppLabel(
                            title: "Open Yelp",
                            systemImage: AppSymbol.review,
                            iconSize: AppIconSize.inline,
                            textFont: .system(.headline, design: .rounded)
                        )
                    }
                    .buttonStyle(.bordered)
                }

                if config.enablePointsForPublicReviews {
                    HStack(spacing: 12) {
                        Button {
                            claimPlatform = .google
                            showClaimConfirmation = true
                        } label: {
                            AppLabel(
                                title: "Claim points for Google",
                                systemImage: AppSymbol.warning,
                                iconSize: AppIconSize.inline,
                                textFont: .system(.subheadline, design: .rounded).weight(.semibold)
                            )
                        }
                        .buttonStyle(.bordered)

                        if config.yelpReviewURL != nil {
                            Button {
                                claimPlatform = .yelp
                                showClaimConfirmation = true
                            } label: {
                                AppLabel(
                                    title: "Claim points for Yelp",
                                    systemImage: AppSymbol.warning,
                                    iconSize: AppIconSize.inline,
                                    textFont: .system(.subheadline, design: .rounded).weight(.semibold)
                                )
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                } else {
                    Text("No points are awarded for public reviews by default.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
