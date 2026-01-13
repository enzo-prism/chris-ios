import Foundation

@MainActor
final class AppDataStore: ObservableObject {
    @Published private(set) var rewards: [Reward] = []
    @Published private(set) var offers: [Offer] = []
    @Published private(set) var specialists: [Specialist] = []
    @Published private(set) var educationTopics: [EducationTopic] = []
    @Published private(set) var offersLastUpdated: Date?
    @Published private(set) var educationLastUpdated: Date?
    @Published private(set) var rewardsLastUpdated: Date?
    @Published private(set) var specialistsLastUpdated: Date?

    private let config: AppConfig
    private let contentService: RemoteContentService

    init(config: AppConfig, contentService: RemoteContentService = RemoteContentService()) {
        self.config = config
        self.contentService = contentService
        loadBundledContent()
        Task {
            await refreshAll()
        }
    }

    func loadBundledContent() {
        rewards = BundleDataService.loadRewards().filter { $0.active }
        offers = BundleDataService.loadOffers()
        specialists = BundleDataService.loadSpecialists()
        educationTopics = BundleDataService.loadEducationTopics()
    }

    func refreshAll() async {
        await refreshOffers()
        await refreshRewards()
        await refreshEducation()
        await refreshSpecialists()
    }

    func refreshOffers() async {
        let result = await contentService.fetchContent(
            url: config.offersFeedURL,
            cacheFileName: "offers.json",
            decoder: BundleDataService.iso8601Decoder
        ) {
            BundleDataService.loadOffers()
        }
        offers = result.items
        offersLastUpdated = result.lastUpdated
    }

    func refreshRewards() async {
        let result = await contentService.fetchContent(
            url: config.rewardsFeedURL,
            cacheFileName: "rewards.json",
            decoder: JSONDecoder()
        ) {
            BundleDataService.loadRewards()
        }
        rewards = result.items.filter { $0.active }
        rewardsLastUpdated = result.lastUpdated
    }

    func refreshEducation() async {
        let result = await contentService.fetchContent(
            url: config.educationFeedURL,
            cacheFileName: "education.json",
            decoder: JSONDecoder()
        ) {
            BundleDataService.loadEducationTopics()
        }
        educationTopics = result.items
        educationLastUpdated = result.lastUpdated
    }

    func refreshSpecialists() async {
        let result = await contentService.fetchContent(
            url: config.specialistsFeedURL,
            cacheFileName: "specialists.json",
            decoder: JSONDecoder()
        ) {
            BundleDataService.loadSpecialists()
        }
        specialists = result.items
        specialistsLastUpdated = result.lastUpdated
    }
}
