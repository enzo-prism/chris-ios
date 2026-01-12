import Foundation
import SwiftUI

struct AppConfig {
    // TODO: Replace Info.plist placeholders with real practice details and endpoints.
    let practiceName: String
    let phone: String
    let address: String
    let websiteURL: URL?
    let instagramHandle: String
    let schedulingURL: URL?
    let googleReviewURL: URL?
    let yelpURL: URL?

    let appointmentEndpoint: URL?
    let referralEndpoint: URL?
    let mediaEndpoint: URL?
    let feedbackEndpoint: URL?
    let redemptionEndpoint: URL?

    // NOT RECOMMENDED: awarding points for public reviews can violate platform policies.
    let enablePointsForPublicReviews: Bool

    let practiceHours: [String]

    init(bundle: Bundle = .main) {
        practiceName = bundle.string(forKey: "PracticeName", fallback: "TODO: Practice Name")
        phone = bundle.string(forKey: "PracticePhone", fallback: "TODO: (000) 000-0000")
        address = bundle.string(forKey: "PracticeAddress", fallback: "TODO: Practice Address")
        websiteURL = bundle.url(forKey: "PracticeWebsite")
        instagramHandle = bundle.string(forKey: "InstagramHandle", fallback: "TODO: @instagram")
        schedulingURL = bundle.url(forKey: "SchedulingURL")
        googleReviewURL = bundle.url(forKey: "GoogleReviewURL")
        yelpURL = bundle.url(forKey: "YelpURL")

        appointmentEndpoint = bundle.url(forKey: "FormspreeAppointmentEndpoint")
        referralEndpoint = bundle.url(forKey: "FormspreeReferralEndpoint")
        mediaEndpoint = bundle.url(forKey: "FormspreeMediaEndpoint")
        feedbackEndpoint = bundle.url(forKey: "FormspreeFeedbackEndpoint")
        redemptionEndpoint = bundle.url(forKey: "FormspreeRedemptionEndpoint")

        enablePointsForPublicReviews = bundle.bool(forKey: "EnablePointsForPublicReviews")
        practiceHours = bundle.array(forKey: "PracticeHours")
    }

    var sanitizedPhone: String {
        phone.filter { "0123456789".contains($0) }
    }

    var phoneURL: URL? {
        URL(string: "tel://\(sanitizedPhone)")
    }

    var mapsURL: URL? {
        let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "http://maps.apple.com/?address=\(encoded)")
    }
}

private extension Bundle {
    func string(forKey key: String, fallback: String) -> String {
        object(forInfoDictionaryKey: key) as? String ?? fallback
    }

    func bool(forKey key: String) -> Bool {
        object(forInfoDictionaryKey: key) as? Bool ?? false
    }

    func url(forKey key: String) -> URL? {
        guard let string = object(forInfoDictionaryKey: key) as? String,
              !string.hasPrefix("TODO"),
              let url = URL(string: string)
        else {
            return nil
        }
        return url
    }

    func array(forKey key: String) -> [String] {
        object(forInfoDictionaryKey: key) as? [String] ?? []
    }
}

struct AppConfigKey: EnvironmentKey {
    static let defaultValue = AppConfig()
}

extension EnvironmentValues {
    var appConfig: AppConfig {
        get { self[AppConfigKey.self] }
        set { self[AppConfigKey.self] = newValue }
    }
}
