import Foundation
import UserNotifications

struct RecallService {
    static func nextDueDate(lastCleaningDate: Date, intervalMonths: Int, calendar: Calendar = .current) -> Date {
        let months = max(intervalMonths, 1)
        return calendar.date(byAdding: .month, value: months, to: lastCleaningDate) ?? lastCleaningDate
    }

    static func isDueSoon(nextDueDate: Date, thresholdDays: Int = 30, calendar: Calendar = .current) -> Bool {
        guard let thresholdDate = calendar.date(byAdding: .day, value: thresholdDays, to: Date()) else {
            return false
        }
        return nextDueDate <= thresholdDate
    }

    static func requestAuthorization() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound])
        } catch {
            return false
        }
    }

    static func scheduleReminder(nextDueDate: Date, hour: Int, minute: Int) async {
        let center = UNUserNotificationCenter.current()
        let content = UNMutableNotificationContent()
        content.title = "Time to schedule"
        content.body = "Time to schedule your next dental visit."
        content.sound = .default

        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: nextDueDate)
        dateComponents.hour = hour
        dateComponents.minute = minute

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "recall-reminder", content: content, trigger: trigger)
        center.removePendingNotificationRequests(withIdentifiers: ["recall-reminder"])
        do {
            try await center.add(request)
        } catch {
            return
        }
    }

    static func cancelReminder() async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["recall-reminder"])
    }
}
