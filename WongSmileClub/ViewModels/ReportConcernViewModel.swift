import Foundation

@MainActor
final class ReportConcernViewModel: ObservableObject {
    enum Category: String, CaseIterable, Identifiable {
        case content = "Inappropriate content"
        case consent = "Consent or rights concern"
        case privacy = "Privacy concern"
        case bug = "App issue"
        case other = "Other"

        var id: String { rawValue }
    }

    @Published var name = ""
    @Published var contact = ""
    @Published var category: Category = .content
    @Published var description = ""
    @Published var status: SubmissionStatus = .idle

    private let config: AppConfig
    private let formspree: FormspreeClientProtocol

    init(config: AppConfig, formspree: FormspreeClientProtocol) {
        self.config = config
        self.formspree = formspree
    }

    func submit() async {
        guard let endpoint = config.reportConcernEndpoint else {
            status = .failure(message: "Reporting endpoint is missing. Contact support instead.")
            return
        }

        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            status = .failure(message: "Please describe the concern.")
            return
        }

        status = .submitting
        let payload: [String: Any] = [
            "name": name,
            "contact": contact,
            "category": category.rawValue,
            "description": description,
            "source": "WongSmileClub"
        ]

        do {
            try await formspree.submitJSON(endpointURL: endpoint, payload: payload)
            status = .success(message: "Thanks for letting us know. We will follow up if needed.")
        } catch {
            status = .failure(message: error.localizedDescription)
        }
    }
}
