import SwiftUI
import SwiftData

struct EarnContentView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @Environment(\.modelContext) private var modelContext

    private var pointsStore: PointsStore {
        PointsStore(context: modelContext)
    }

    var body: some View {
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
                    description: "Tag \(config.instagramHandleDisplay) in your post.",
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

            Text("Referral, social, and media rewards are subject to verification at redemption.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .padding(.top, 4)
        }
    }
}
