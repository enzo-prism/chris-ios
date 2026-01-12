import Foundation

struct BundleDataService {
    static func loadRewards() -> [Reward] {
        loadArray(resource: "Rewards", decoder: JSONDecoder())
    }

    static func loadOffers() -> [Offer] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return loadArray(resource: "Offers", decoder: decoder)
    }

    private static func loadArray<T: Decodable>(resource: String, decoder: JSONDecoder) -> [T] {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json") else {
            return []
        }
        do {
            let data = try Data(contentsOf: url)
            return try decoder.decode([T].self, from: data)
        } catch {
            return []
        }
    }
}
