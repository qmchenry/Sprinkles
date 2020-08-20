import XCTest
@testable import Sprinkles

final class SprinklesTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(Sprinkles().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
