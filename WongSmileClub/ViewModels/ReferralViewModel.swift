import Foundation

@MainActor
final class ReferralViewModel: ObservableObject {
    @Published var yourName = ""
    @Published var yourPhone = ""
    @Published var yourEmail = ""
    @Published var friendName = ""
    @Published var friendPhone = ""
    @Published var friendEmail = ""
    @Published var whyGoodFit = ""
    @Published var hasPermission = false
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
        guard hasPermission else {
            status = .failure(message: "Please confirm you have permission to share your friend's contact info.")
            return
        }
        guard let endpoint = config.referralEndpoint else {
            status = .failure(message: "Referral endpoint is missing. Update Info.plist.")
            return
        }

        status = .submitting
        let payload: [String: Any] = [
            "yourName": yourName,
            "yourPhone": yourPhone,
            "yourEmail": yourEmail,
            "friendName": friendName,
            "friendPhone": friendPhone,
            "friendEmail": friendEmail,
            "whyGoodFit": whyGoodFit,
            "permission": hasPermission ? "yes" : "no",
            "source": "WongSmileClub"
        ]

        do {
            try await formspree.submitJSON(endpointURL: endpoint, payload: payload)
            pointsStore.addTransaction(PointsTransaction(type: .earn, source: .referral, points: PointsValues.referral, note: "Referral"))
            status = .success(message: "Referral received. We will follow up soon.")
        } catch {
            status = .failure(message: error.localizedDescription)
        }
    }
}
