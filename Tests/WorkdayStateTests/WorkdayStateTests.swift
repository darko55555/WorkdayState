import XCTest
@testable import WorkdayState

final class WorkdayStateTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(WorkdayState().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
