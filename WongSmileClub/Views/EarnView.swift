import SwiftUI
import SwiftData

struct EarnView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @Environment(\.modelContext) private var modelContext
    @State private var showSafari = false
    @State private var safariURL: URL?

    private var pointsStore: PointsStore {
        PointsStore(context: modelContext)
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    SectionHeader(title: "Earn Smile Points", systemImage: AppSymbol.earn)

                    NavigationLink {
                        ReferralView(pointsStore: pointsStore, config: config, formspree: formspree)
                    } label: {
                        EarnTaskCard(
                            title: "Refer a Friend",
                            description: "Invite someone you care about to WongSmileClub.",
                            systemImage: AppSymbol.referral,
                            points: PointsValues.referral,
                            footnote: "Subject to verification at redemption."
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        MediaSubmissionView(mediaType: .photo, pointsStore: pointsStore, config: config, formspree: formspree)
                    } label: {
                        EarnTaskCard(
                            title: "Submit Smile Photo",
                            description: "Share your smile for a bonus.",
                            systemImage: AppSymbol.photo,
                            points: PointsValues.photo,
                            footnote: "Subject to verification at redemption."
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        MediaSubmissionView(mediaType: .video, pointsStore: pointsStore, config: config, formspree: formspree)
                    } label: {
                        EarnTaskCard(
                            title: "Submit Smile Video",
                            description: "Short video about your experience.",
                            systemImage: AppSymbol.video,
                            points: PointsValues.video,
                            footnote: "Subject to verification at redemption."
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        InstagramTagView(pointsStore: pointsStore)
                    } label: {
                        EarnTaskCard(
                            title: "Instagram Tag",
                            description: "Tag \(config.instagramHandle) in your post.",
                            systemImage: AppSymbol.instagram,
                            points: PointsValues.instagram,
                            footnote: "Subject to verification at redemption."
                        )
                    }
                    .buttonStyle(.plain)

                    NavigationLink {
                        FeedbackView(pointsStore: pointsStore, config: config, formspree: formspree)
                    } label: {
                        EarnTaskCard(
                            title: "Private Feedback",
                            description: "Tell us how we did in a quick survey.",
                            systemImage: AppSymbol.feedback,
                            points: PointsValues.feedback,
                            footnote: "We appreciate the private feedback."
                        )
                    }
                    .buttonStyle(.plain)

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Google Review")
                                    .font(.system(.headline, design: .rounded))
                                Spacer()
                                if config.enablePointsForPublicReviews {
                                    PointsPill(points: PointsValues.publicReview)
                                } else {
                                    Text("No points")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Text("Open Google Reviews in a secure browser.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Button {
                                safariURL = config.googleReviewURL
                                showSafari = safariURL != nil
                            } label: {
                                AppLabel(
                                    title: "Open Google Reviews",
                                    systemImage: AppSymbol.review,
                                    iconSize: AppIconSize.inline,
                                    textFont: .system(.headline, design: .rounded)
                                )
                            }
                            .buttonStyle(.borderedProminent)

                            if config.enablePointsForPublicReviews {
                                Button {
                                    pointsStore.addTransaction(PointsTransaction(type: .earn, source: .publicReviewGoogle, points: PointsValues.publicReview, note: "Public review (NOT RECOMMENDED)"))
                                } label: {
                                    AppLabel(
                                        title: "Claim Points (NOT RECOMMENDED)",
                                        systemImage: AppSymbol.warning,
                                        iconSize: AppIconSize.inline,
                                        textFont: .system(.subheadline, design: .rounded).weight(.semibold)
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Yelp Review")
                                    .font(.system(.headline, design: .rounded))
                                Spacer()
                                if config.enablePointsForPublicReviews {
                                    PointsPill(points: PointsValues.publicReview)
                                } else {
                                    Text("No points")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }

                            Text("Open Yelp in a secure browser.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Button {
                                safariURL = config.yelpURL
                                showSafari = safariURL != nil
                            } label: {
                                AppLabel(
                                    title: "Open Yelp",
                                    systemImage: AppSymbol.review,
                                    iconSize: AppIconSize.inline,
                                    textFont: .system(.headline, design: .rounded)
                                )
                            }
                            .buttonStyle(.borderedProminent)

                            if config.enablePointsForPublicReviews {
                                Button {
                                    pointsStore.addTransaction(PointsTransaction(type: .earn, source: .publicReviewYelp, points: PointsValues.publicReview, note: "Public review (NOT RECOMMENDED)"))
                                } label: {
                                    AppLabel(
                                        title: "Claim Points (NOT RECOMMENDED)",
                                        systemImage: AppSymbol.warning,
                                        iconSize: AppIconSize.inline,
                                        textFont: .system(.subheadline, design: .rounded).weight(.semibold)
                                    )
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                    }

                    Text("Referral, social, and media rewards are subject to verification at redemption.")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Earn")
        .sheet(isPresented: $showSafari) {
            if let safariURL {
                SafariView(url: safariURL)
            }
        }
    }
}
