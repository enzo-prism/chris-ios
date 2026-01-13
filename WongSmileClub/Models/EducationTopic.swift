import Foundation

struct EducationTopic: Identifiable, Codable {
    let id: String
    let title: String
    let shortSummary: String
    let category: String
    let tags: [String]
    let whenToCallOffice: [String]
    let doDont: [String]
    let links: [ReferenceLink]
}

struct ReferenceLink: Identifiable, Codable {
    let id: String
    let title: String
    let url: String
    let sourceLabel: String?

    var urlValue: URL? {
        URL(string: url)
    }
}
