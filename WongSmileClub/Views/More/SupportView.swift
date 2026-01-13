import SwiftUI

struct SupportView: View {
    @Environment(\.appConfig) private var config
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Support", systemImage: AppSymbol.support)

                            Text("Need help? Contact the practice support team.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if let emailURL = config.supportEmailURL {
                                Button {
                                    openURL(emailURL)
                                } label: {
                                    AppLabel(
                                        title: config.supportEmail,
                                        systemImage: AppSymbol.support,
                                        textFont: .system(.subheadline, design: .rounded)
                                    )
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Text("Support email: \(config.supportEmailDisplay)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            if let phoneURL = config.phoneURL {
                                Button {
                                    openURL(phoneURL)
                                } label: {
                                    AppLabel(
                                        title: config.phoneDisplay,
                                        systemImage: AppSymbol.call,
                                        textFont: .system(.subheadline, design: .rounded)
                                    )
                                }
                                .buttonStyle(.bordered)
                            } else {
                                Text("Office phone: \(config.phoneDisplay)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Support")
    }
}
