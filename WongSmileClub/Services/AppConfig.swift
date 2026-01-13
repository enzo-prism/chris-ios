import Foundation
import SwiftUI

struct AppConfig {
    // TODO: Replace Info.plist placeholders with real practice details and endpoints.
    let practiceName: String
    let practiceCity: String
    let phone: String
    let emergencyPhone: String
    let address: String
    let websiteURL: URL?
    let instagramHandle: String
    let schedulingURL: URL?
    let patientPortalURL: URL?
    let googleReviewURL: URL?
    let yelpReviewURL: URL?
    let supportEmail: String
    let privacyPolicyURL: URL?
    let termsURL: URL?
    let communityGuidelinesURL: URL?

    let appointmentEndpoint: URL?
    let referralEndpoint: URL?
    let mediaEndpoint: URL?
    let feedbackEndpoint: URL?
    let redemptionEndpoint: URL?
    let specialistCoordinationEndpoint: URL?
    let reportConcernEndpoint: URL?

    // NOT RECOMMENDED: awarding points for public reviews can violate platform policies.
    let enablePointsForPublicReviews: Bool
    let enableDemoCareData: Bool

    let practiceHours: [String]
    let instagramDisclosureText: String

    let offersFeedURL: URL?
    let rewardsFeedURL: URL?
    let educationFeedURL: URL?
    let specialistsFeedURL: URL?

    init(bundle: Bundle = .main) {
        practiceName = bundle.stringValue(forKeys: ["PracticeName"], fallback: "TODO: Practice Name")
        practiceCity = bundle.stringValue(forKeys: ["PracticeCity"], fallback: "TODO: City")
        phone = bundle.stringValue(forKeys: ["PracticePhone"], fallback: "TODO: (000) 000-0000")
        emergencyPhone = bundle.stringValue(forKeys: ["EmergencyPhone"], fallback: phone)
        address = bundle.stringValue(forKeys: ["PracticeAddress"], fallback: "TODO: Practice Address")
        websiteURL = bundle.urlValue(forKeys: ["PracticeWebsiteURL", "PracticeWebsite"])
        instagramHandle = bundle.stringValue(forKeys: ["PracticeInstagramHandle", "InstagramHandle"], fallback: "TODO: @instagram")
        schedulingURL = bundle.urlValue(forKeys: ["PracticeSchedulingURL", "SchedulingURL"])
        patientPortalURL = bundle.urlValue(forKeys: ["PracticePatientPortalURL", "PatientPortalURL"])
        googleReviewURL = bundle.urlValue(forKeys: ["GoogleReviewURL"])
        yelpReviewURL = bundle.urlValue(forKeys: ["YelpReviewURL", "YelpURL"])
        supportEmail = bundle.stringValue(forKeys: ["SupportEmail"], fallback: "TODO: support@example.com")
        privacyPolicyURL = bundle.urlValue(forKeys: ["PrivacyPolicyURL"])
        termsURL = bundle.urlValue(forKeys: ["TermsURL"])
        communityGuidelinesURL = bundle.urlValue(forKeys: ["CommunityGuidelinesURL"])

        appointmentEndpoint = bundle.urlValue(forKeys: ["FormspreeAppointmentEndpoint"])
        referralEndpoint = bundle.urlValue(forKeys: ["FormspreeReferralEndpoint"])
        mediaEndpoint = bundle.urlValue(forKeys: ["FormspreeMediaEndpoint"])
        feedbackEndpoint = bundle.urlValue(forKeys: ["FormspreeFeedbackEndpoint"])
        redemptionEndpoint = bundle.urlValue(forKeys: ["FormspreeRedemptionEndpoint"])
        specialistCoordinationEndpoint = bundle.urlValue(forKeys: ["FormspreeSpecialistCoordinationEndpoint"])
        reportConcernEndpoint = bundle.urlValue(forKeys: ["FormspreeReportConcernEndpoint"])

        enablePointsForPublicReviews = bundle.bool(forKey: "EnablePointsForPublicReviews")
#if DEBUG
        enableDemoCareData = bundle.bool(forKey: "EnableDemoCareData")
#else
        enableDemoCareData = false
#endif
        practiceHours = bundle.array(forKey: "PracticeHours")

        let disclosureFallback = bundle.stringValue(forKeys: ["InstagramDisclosureText"], fallback: "")
        if disclosureFallback.isEmpty || disclosureFallback.hasPrefix("TODO") {
            let handle = instagramHandle.hasPrefix("TODO") ? "our dental team" : instagramHandle
            instagramDisclosureText = "Thanks \(handle) for taking care of my smile! #ad"
        } else {
            instagramDisclosureText = disclosureFallback
        }

        offersFeedURL = bundle.urlValue(forKeys: ["OffersFeedURL"])
        rewardsFeedURL = bundle.urlValue(forKeys: ["RewardsFeedURL"])
        educationFeedURL = bundle.urlValue(forKeys: ["EducationFeedURL"])
        specialistsFeedURL = bundle.urlValue(forKeys: ["SpecialistsFeedURL"])
    }

    private func sanitizedDigits(from value: String) -> String {
        value.filter { "0123456789".contains($0) }
    }

    var sanitizedPhone: String {
        sanitizedDigits(from: phone)
    }

    var sanitizedEmergencyPhone: String {
        sanitizedDigits(from: emergencyPhone)
    }

    var phoneURL: URL? {
        guard !isPlaceholder(phone) else { return nil }
        return URL(string: "tel://\(sanitizedPhone)")
    }

    var emergencyPhoneURL: URL? {
        guard !isPlaceholder(emergencyPhone) else { return nil }
        return URL(string: "tel://\(sanitizedEmergencyPhone)")
    }

    var mapsURL: URL? {
        guard !isPlaceholder(address) else { return nil }
        let encoded = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return URL(string: "http://maps.apple.com/?address=\(encoded)")
    }

    var supportEmailURL: URL? {
        guard !isPlaceholder(supportEmail) else { return nil }
        return URL(string: "mailto:\(supportEmail)")
    }

    var phoneDisplay: String {
        displayValue(phone)
    }

    var emergencyPhoneDisplay: String {
        displayValue(emergencyPhone)
    }

    var addressDisplay: String {
        displayValue(address)
    }

    var supportEmailDisplay: String {
        displayValue(supportEmail)
    }

    var instagramHandleDisplay: String {
        displayValue(instagramHandle)
    }

    private func displayValue(_ value: String) -> String {
        isPlaceholder(value) ? "Not configured" : value
    }

    private func isPlaceholder(_ value: String) -> Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || value.hasPrefix("TODO")
    }
}

private extension Bundle {
    func stringValue(forKeys keys: [String], fallback: String) -> String {
        for key in keys {
            if let value = object(forInfoDictionaryKey: key) as? String, !value.isEmpty {
                return value
            }
        }
        return fallback
    }

    func bool(forKey key: String) -> Bool {
        object(forInfoDictionaryKey: key) as? Bool ?? false
    }

    func urlValue(forKeys keys: [String]) -> URL? {
        for key in keys {
            guard let string = object(forInfoDictionaryKey: key) as? String,
                  !string.hasPrefix("TODO"),
                  let url = URL(string: string)
            else {
                continue
            }
            return url
        }
        return nil
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
