import SwiftUI

struct FeedbackSuccessView: View {
    let message: String
    let googleURL: URL?
    let yelpURL: URL?

    @Environment(\.dismiss) private var dismiss
    @State private var showSafari = false
    @State private var safariURL: URL?

    var body: some View {
        ZStack {
            AppBackground()

            VStack(spacing: 20) {
                AppIcon(name: AppSymbol.success, size: AppIconSize.hero, weight: .bold, color: .accentColor)

                Text("Feedback Sent")
                    .font(.system(.title2, design: .rounded).weight(.bold))

                Text(message)
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

                if googleURL != nil || yelpURL != nil {
                    Text("Optional: Leave a public review (no points awarded by default).")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                if let googleURL {
                    Button {
                        safariURL = googleURL
                        showSafari = true
                    } label: {
                        AppLabel(
                            title: "Leave a Google Review",
                            systemImage: AppSymbol.review,
                            iconSize: AppIconSize.inline,
                            textFont: .system(.headline, design: .rounded)
                        )
                    }
                    .buttonStyle(.borderedProminent)
                }

                if let yelpURL {
                    Button {
                        safariURL = yelpURL
                        showSafari = true
                    } label: {
                        AppLabel(
                            title: "Leave a Yelp Review",
                            systemImage: AppSymbol.review,
                            iconSize: AppIconSize.inline,
                            textFont: .system(.headline, design: .rounded)
                        )
                    }
                    .buttonStyle(.bordered)
                }

                PrimaryButton(title: "Done", systemImage: AppSymbol.confirm) {
                    dismiss()
                }
            }
            .padding(24)
        }
        .sheet(isPresented: $showSafari) {
            if let safariURL {
                SafariView(url: safariURL)
            }
        }
    }
}
