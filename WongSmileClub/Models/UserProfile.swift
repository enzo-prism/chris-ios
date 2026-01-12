import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID
    var name: String
    var phone: String
    var email: String
    var consentRepost: Bool
    var consentMarketing: Bool

    init(id: UUID = UUID(), name: String = "", phone: String = "", email: String = "", consentRepost: Bool = false, consentMarketing: Bool = false) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.consentRepost = consentRepost
        self.consentMarketing = consentMarketing
    }
}
