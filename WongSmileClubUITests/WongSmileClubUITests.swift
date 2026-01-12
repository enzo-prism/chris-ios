import XCTest

final class WongSmileClubUITests: XCTestCase {
    func testTabsExist() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars
        XCTAssertTrue(tabBar.buttons["Home"].exists)
        XCTAssertTrue(tabBar.buttons["Book"].exists)
        XCTAssertTrue(tabBar.buttons["Earn"].exists)
        XCTAssertTrue(tabBar.buttons["Rewards"].exists)
        XCTAssertTrue(tabBar.buttons["Offers"].exists)
    }
}
