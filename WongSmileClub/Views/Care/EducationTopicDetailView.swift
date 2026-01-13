import SwiftUI

struct EducationTopicDetailView: View {
    let topic: EducationTopic

    @EnvironmentObject private var dataStore: AppDataStore
    @Environment(\.appConfig) private var config
    @Environment(\.openURL) private var openURL
    @State private var showSafari = false
    @State private var safariURL: URL?

    private var suggestedSpecialists: [Specialist] {
        SpecialistMatcher.suggestedSpecialists(for: topic, from: dataStore.specialists, limit: 3)
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    summaryCard

                    doDontCard

                    whenToCallCard

                    if !suggestedSpecialists.isEmpty {
                        specialistsCard
                    }

                    learnMoreCard

                    disclaimerCard
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle(topic.title)
        .sheet(isPresented: $showSafari) {
            if let safariURL {
                SafariView(url: safariURL)
            }
        }
    }

    private var summaryCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Summary", systemImage: AppSymbol.education)
                Text(topic.shortSummary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var doDontCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Do / Don't", systemImage: AppSymbol.checklist)
                ForEach(topic.doDont, id: \.self) { item in
                    Text("• \(item)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var whenToCallCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "When to call the office", systemImage: AppSymbol.call)
                ForEach(topic.whenToCallOffice, id: \.self) { item in
                    Text("• \(item)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                if let url = config.phoneURL {
                    Button {
                        openURL(url)
                    } label: {
                        AppLabel(
                            title: "Call the office",
                            systemImage: AppSymbol.call,
                            textFont: .system(.subheadline, design: .rounded)
                        )
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    Text("Phone number not configured.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private var specialistsCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Specialists", systemImage: AppSymbol.specialists)
                Text("Dr. Wong's specialist network can help if you need extra care.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                ForEach(suggestedSpecialists) { specialist in
                    NavigationLink {
                        SpecialistDetailView(specialist: specialist)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(specialist.name)
                                    .font(.subheadline)
                                Text(specialist.category)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            AppIcon(name: AppSymbol.specialists, size: AppIconSize.inline, weight: .semibold)
                                .accessibilityHidden(true)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var learnMoreCard: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader(title: "Learn more", systemImage: AppSymbol.link)
                if topic.links.isEmpty {
                    Text("No additional links available.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(topic.links) { link in
                        Button {
                            safariURL = link.urlValue
                            showSafari = safariURL != nil
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(link.title)
                                        .font(.subheadline)
                                    if let source = link.sourceLabel {
                                        Text(source)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                AppIcon(name: AppSymbol.link, size: AppIconSize.inline, weight: .semibold)
                                    .accessibilityHidden(true)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
        }
    }

    private var disclaimerCard: some View {
        GlassCard {
            Text("Educational only. For medical advice, contact the practice.")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}
