import Foundation

struct SpecialistMatcher {
    private static let tagToCategory: [String: String] = [
        "toothache": "Endodontist",
        "sensitivity": "Endodontist",
        "gum-health": "Periodontist",
        "hygiene": "Periodontist",
        "invisalign": "Orthodontist",
        "orthodontics": "Orthodontist",
        "bite-wear": "Oral Surgeon",
        "chipped-tooth": "Oral Surgeon",
        "emergency": "Oral Surgeon"
    ]

    static func suggestedSpecialists(for topic: EducationTopic, from specialists: [Specialist], limit: Int = 3) -> [Specialist] {
        let topicTags = Set(topic.tags)
        if !topicTags.isEmpty {
            let directMatches = specialists.filter { !Set($0.tags).isDisjoint(with: topicTags) }
            if !directMatches.isEmpty {
                return Array(directMatches.prefix(limit))
            }
        }

        let mappedCategories = topic.tags.compactMap { tagToCategory[$0] }
        if !mappedCategories.isEmpty {
            let matches = specialists.filter { mappedCategories.contains($0.category) }
            return Array(matches.prefix(limit))
        }

        return Array(specialists.prefix(limit))
    }
}
