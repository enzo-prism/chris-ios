import SwiftUI

struct LegalMenuView: View {
    @Environment(\.appConfig) private var config
    @State private var showSafari = false
    @State private var safariURL: URL?

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Legal", systemImage: AppSymbol.legal)

                            legalLinkRow(title: "Terms of Service", url: config.termsURL)

                            legalLinkRow(title: "Privacy Policy", url: config.privacyPolicyURL)

                            if config.communityGuidelinesURL != nil {
                                legalLinkRow(title: "Community Guidelines", url: config.communityGuidelinesURL)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Legal")
        .sheet(isPresented: $showSafari) {
            if let safariURL {
                SafariView(url: safariURL)
            }
        }
    }

    @ViewBuilder
    private func legalLinkRow(title: String, url: URL?) -> some View {
        if let url {
            Button(title) {
                safariURL = url
                showSafari = true
            }
            .buttonStyle(.plain)
        } else {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                Text("Not configured")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
