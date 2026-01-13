import XCTest
@testable import WongSmileClub

final class RecallServiceTests: XCTestCase {
    func testNextDueDateAddsMonths() {
        let calendar = Calendar(identifier: .gregorian)
        let start = calendar.date(from: DateComponents(year: 2025, month: 1, day: 15))!

        let dueDate = RecallService.nextDueDate(lastCleaningDate: start, intervalMonths: 6, calendar: calendar)
        let components = calendar.dateComponents([.year, .month, .day], from: dueDate)

        XCTAssertEqual(components.year, 2025)
        XCTAssertEqual(components.month, 7)
        XCTAssertEqual(components.day, 15)
    }

    func testIsDueSoon() {
        let calendar = Calendar(identifier: .gregorian)
        let soonDate = calendar.date(byAdding: .day, value: 10, to: Date())!
        let laterDate = calendar.date(byAdding: .day, value: 90, to: Date())!

        XCTAssertTrue(RecallService.isDueSoon(nextDueDate: soonDate, thresholdDays: 30, calendar: calendar))
        XCTAssertFalse(RecallService.isDueSoon(nextDueDate: laterDate, thresholdDays: 30, calendar: calendar))
    }
}
