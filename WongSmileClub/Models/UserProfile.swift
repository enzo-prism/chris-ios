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
    var pendingAppointmentSummary: String
    var pendingAppointmentRequestedAt: Date?
    var lastCleaningDate: Date?
    var recallIntervalMonths: Int
    var recallNotificationsEnabled: Bool
    var preferredReminderHour: Int
    var preferredReminderMinute: Int

    init(
        id: UUID = UUID(),
        name: String = "",
        phone: String = "",
        email: String = "",
        consentRepost: Bool = false,
        consentMarketing: Bool = false,
        pendingAppointmentSummary: String = "",
        pendingAppointmentRequestedAt: Date? = nil,
        lastCleaningDate: Date? = nil,
        recallIntervalMonths: Int = 6,
        recallNotificationsEnabled: Bool = false,
        preferredReminderHour: Int = 9,
        preferredReminderMinute: Int = 0
    ) {
        self.id = id
        self.name = name
        self.phone = phone
        self.email = email
        self.consentRepost = consentRepost
        self.consentMarketing = consentMarketing
        self.pendingAppointmentSummary = pendingAppointmentSummary
        self.pendingAppointmentRequestedAt = pendingAppointmentRequestedAt
        self.lastCleaningDate = lastCleaningDate
        self.recallIntervalMonths = recallIntervalMonths
        self.recallNotificationsEnabled = recallNotificationsEnabled
        self.preferredReminderHour = preferredReminderHour
        self.preferredReminderMinute = preferredReminderMinute
    }
}
