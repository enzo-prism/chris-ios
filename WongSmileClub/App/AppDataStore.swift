import Foundation

@MainActor
final class AppDataStore: ObservableObject {
    @Published private(set) var rewards: [Reward] = []
    @Published private(set) var offers: [Offer] = []

    init() {
        load()
    }

    func load() {
        rewards = BundleDataService.loadRewards().filter { $0.active }
        offers = BundleDataService.loadOffers()
    }
}
