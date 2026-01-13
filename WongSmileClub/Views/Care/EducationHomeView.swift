import SwiftUI

struct EducationHomeView: View {
    @EnvironmentObject private var dataStore: AppDataStore
    @State private var searchText = ""
    @State private var selectedCategory: String? = nil

    private var categories: [String] {
        let unique = Set(dataStore.educationTopics.map { $0.category })
        return unique.sorted()
    }

    private var filteredTopics: [EducationTopic] {
        dataStore.educationTopics.filter { topic in
            let matchesCategory = selectedCategory == nil || topic.category == selectedCategory
            let matchesSearch = searchText.isEmpty || topic.title.localizedCaseInsensitiveContains(searchText) || topic.shortSummary.localizedCaseInsensitiveContains(searchText)
            return matchesCategory && matchesSearch
        }
    }

    var body: some View {
        ZStack {
            AppBackground()

            ScrollView {
                VStack(spacing: 16) {
                    SectionHeader(title: "Aftercare & Education", systemImage: AppSymbol.education)

                    if let lastUpdated = dataStore.educationLastUpdated {
                        Text("Last updated \(DateFormatter.shortDateTime.string(from: lastUpdated))")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    categoryChips

                    if filteredTopics.isEmpty {
                        GlassCard {
                            Text("No topics found.")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    } else {
                        ForEach(filteredTopics) { topic in
                            NavigationLink {
                                EducationTopicDetailView(topic: topic)
                            } label: {
                                GlassCard {
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(topic.title)
                                            .font(.system(.headline, design: .rounded))
                                        Text(topic.shortSummary)
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Education")
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .automatic))
        .refreshable {
            await dataStore.refreshEducation()
        }
    }

    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                Button {
                    selectedCategory = nil
                } label: {
                    TagChip(text: "All")
                }
                .buttonStyle(.plain)

                ForEach(categories, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        TagChip(text: category)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
