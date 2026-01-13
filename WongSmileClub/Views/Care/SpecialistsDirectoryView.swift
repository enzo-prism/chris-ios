import SwiftUI

struct SpecialistsDirectoryView: View {
    @EnvironmentObject private var dataStore: AppDataStore

    private var groupedSpecialists: [(category: String, specialists: [Specialist])] {
        let grouped = Dictionary(grouping: dataStore.specialists, by: { $0.category })
        return grouped.keys.sorted().map { category in
            let specialists = grouped[category]?.sorted { $0.name < $1.name } ?? []
            return (category: category, specialists: specialists)
        }
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    if let lastUpdated = dataStore.specialistsLastUpdated {
                        Text("Last updated \(DateFormatter.shortDateTime.string(from: lastUpdated))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    if groupedSpecialists.isEmpty {
                        GlassCard {
                            Text("No specialists available yet.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        ForEach(groupedSpecialists, id: \.category) { group in
                            VStack(alignment: .leading, spacing: 12) {
                                SectionHeader(title: group.category, systemImage: AppSymbol.specialists)

                                ForEach(group.specialists) { specialist in
                                    NavigationLink {
                                        SpecialistDetailView(specialist: specialist, specialists: dataStore.specialists)
                                    } label: {
                                        SpecialistRowView(specialist: specialist)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Specialists")
        .refreshable {
            await dataStore.refreshSpecialists()
        }
    }
}

struct SpecialistRowView: View {
    let specialist: Specialist

    var body: some View {
        GlassCard {
            VStack(alignment: .leading, spacing: 6) {
                Text(specialist.name)
                    .font(.system(.headline, design: .rounded))
                Text(specialist.practiceName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Text(specialist.whyRecommended)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
