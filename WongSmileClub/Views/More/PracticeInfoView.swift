import SwiftUI

struct PracticeInfoView: View {
    @Environment(\.appConfig) private var config

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionHeader(title: "Practice Info", systemImage: AppSymbol.practice)
                            Text(config.practiceName)
                                .font(.headline)
                            Text(config.practiceCity)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(config.addressDisplay)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            Text(config.phoneDisplay)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)

                            if let url = config.websiteURL {
                                Link("Visit Website", destination: url)
                            } else {
                                Text("Website not configured")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            if !config.practiceHours.isEmpty {
                                Divider()
                                ForEach(config.practiceHours, id: \.self) { hour in
                                    Text(hour)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Practice Info")
    }
}
