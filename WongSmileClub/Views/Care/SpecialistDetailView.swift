import SwiftUI

struct SpecialistDetailView: View {
    let specialist: Specialist
    let specialists: [Specialist]

    @Environment(\.appConfig) private var config
    @Environment(\.formspreeClient) private var formspree
    @Environment(\.openURL) private var openURL

    init(specialist: Specialist, specialists: [Specialist] = []) {
        self.specialist = specialist
        self.specialists = specialists
    }

    var body: some View {
        let referralList = specialists.isEmpty ? [specialist] : specialists

        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(specialist.name)
                                .font(.system(.title2, design: .rounded).weight(.bold))
                            Text(specialist.practiceName)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(specialist.category)
                                .font(.caption)
                                .foregroundStyle(.secondary)

                            Text(specialist.whyRecommended)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            Text(specialist.address)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }

                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Contact", systemImage: AppSymbol.call)

                            Button {
                                if let url = specialist.phoneURL {
                                    openURL(url)
                                }
                            } label: {
                                AppLabel(
                                    title: "Call \(specialist.phone)",
                                    systemImage: AppSymbol.call,
                                    iconSize: AppIconSize.inline,
                                    textFont: .system(.headline, design: .rounded)
                                )
                            }
                            .buttonStyle(.borderedProminent)

                            Button {
                                if let url = specialist.mapsURL {
                                    openURL(url)
                                }
                            } label: {
                                AppLabel(
                                    title: "Directions",
                                    systemImage: AppSymbol.directions,
                                    iconSize: AppIconSize.inline,
                                    textFont: .system(.headline, design: .rounded)
                                )
                            }
                            .buttonStyle(.bordered)

                            Button {
                                if let url = specialist.websiteLink {
                                    openURL(url)
                                }
                            } label: {
                                AppLabel(
                                    title: "Visit Website",
                                    systemImage: AppSymbol.link,
                                    iconSize: AppIconSize.inline,
                                    textFont: .system(.headline, design: .rounded)
                                )
                            }
                            .buttonStyle(.bordered)
                        }
                    }

                    NavigationLink {
                        SpecialistReferralRequestView(
                            specialists: referralList,
                            selectedSpecialist: specialist,
                            config: config,
                            formspree: formspree
                        )
                    } label: {
                        PrimaryButtonLabel(title: "Request help coordinating a referral", systemImage: AppSymbol.specialists)
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Specialist")
    }
}
