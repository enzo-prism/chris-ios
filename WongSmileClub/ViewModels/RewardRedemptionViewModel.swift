import Foundation

@MainActor
final class RewardRedemptionViewModel: ObservableObject {
    @Published var name = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var note = ""
    @Published var status: SubmissionStatus = .idle

    private let config: AppConfig
    private let formspree: FormspreeClientProtocol
    private let pointsStore: PointsStore

    init(config: AppConfig, formspree: FormspreeClientProtocol, pointsStore: PointsStore) {
        self.config = config
        self.formspree = formspree
        self.pointsStore = pointsStore
    }

    func submit(reward: Reward, currentBalance: Int) async {
        guard let endpoint = config.redemptionEndpoint else {
            status = .failure(message: "Redemption endpoint is missing. Update Info.plist.")
            return
        }

        status = .submitting
        let payload: [String: Any] = [
            "rewardId": reward.id,
            "rewardTitle": reward.title,
            "pointsCost": reward.pointsCost,
            "currentBalance": currentBalance,
            "name": name,
            "phone": phone,
            "email": email,
            "note": note,
            "source": "WongSmileClub"
        ]

        do {
            try await formspree.submitJSON(endpointURL: endpoint, payload: payload)
            pointsStore.addTransaction(PointsTransaction(type: .redeem, source: .rewardRedemption, points: reward.pointsCost, note: reward.title))
            status = .success(message: "We will contact you shortly to deliver the prize.")
        } catch {
            status = .failure(message: error.localizedDescription)
        }
    }
}
