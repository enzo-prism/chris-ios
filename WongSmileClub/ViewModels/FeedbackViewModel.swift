import Foundation

@MainActor
final class FeedbackViewModel: ObservableObject {
    @Published var rating = 5
    @Published var positives = ""
    @Published var improvements = ""
    @Published var status: SubmissionStatus = .idle

    private let config: AppConfig
    private let formspree: FormspreeClientProtocol
    private let pointsStore: PointsStore

    init(config: AppConfig, formspree: FormspreeClientProtocol, pointsStore: PointsStore) {
        self.config = config
        self.formspree = formspree
        self.pointsStore = pointsStore
    }

    func submit() async {
        guard let endpoint = config.feedbackEndpoint else {
            status = .failure(message: "Feedback endpoint is missing. Update Info.plist.")
            return
        }

        status = .submitting
        let payload: [String: Any] = [
            "rating": rating,
            "positives": positives,
            "improvements": improvements,
            "source": "WongSmileClub"
        ]

        do {
            try await formspree.submitJSON(endpointURL: endpoint, payload: payload)
            pointsStore.addTransaction(PointsTransaction(type: .earn, source: .feedback, points: PointsValues.feedback, note: "Private feedback"))
            status = .success(message: "Thanks for the feedback.")
        } catch {
            status = .failure(message: error.localizedDescription)
        }
    }
}
