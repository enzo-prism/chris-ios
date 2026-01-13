import XCTest

final class WongSmileClubUITests: XCTestCase {
    func testTabsExist() {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars
        XCTAssertTrue(tabBar.buttons["Care"].exists)
        XCTAssertTrue(tabBar.buttons["Book"].exists)
        XCTAssertTrue(tabBar.buttons["Club"].exists)
        XCTAssertTrue(tabBar.buttons["Offers"].exists)
        XCTAssertTrue(tabBar.buttons["More"].exists)
    }
}
