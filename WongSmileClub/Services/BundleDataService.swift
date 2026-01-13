import Foundation

struct BundleDataService {
    static func loadRewards() -> [Reward] {
        loadArray(resource: "Rewards", decoder: JSONDecoder())
    }

    static func loadOffers() -> [Offer] {
        loadArray(resource: "Offers", decoder: iso8601Decoder)
    }

    static func loadSpecialists() -> [Specialist] {
        loadArray(resource: "Specialists", decoder: JSONDecoder())
    }

    static func loadEducationTopics() -> [EducationTopic] {
        loadArray(resource: "EducationTopics", decoder: JSONDecoder())
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

    static var iso8601Decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
