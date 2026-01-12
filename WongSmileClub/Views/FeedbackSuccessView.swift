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
                Image(systemName: "checkmark.seal.fill")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(Color.accentColor)

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
                        Label("Leave a Google Review", systemImage: "globe")
                    }
                    .buttonStyle(.borderedProminent)
                }

                if let yelpURL {
                    Button {
                        safariURL = yelpURL
                        showSafari = true
                    } label: {
                        Label("Leave a Yelp Review", systemImage: "globe")
                    }
                    .buttonStyle(.bordered)
                }

                PrimaryButton(title: "Done", systemImage: "checkmark") {
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
