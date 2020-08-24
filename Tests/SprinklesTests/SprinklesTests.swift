import XCTest
@testable import Sprinkles

final class SprinklesTests: XCTestCase {

    func testUIColorLuminance() {

    }

    // values from https://webaim.org/resources/contrastchecker/ and https://contrast-ratio.com
    func testUIColorContrast() {
        let black = UIColor.black
        let white = UIColor.white
        let red = UIColor.red
        let green = UIColor.green
        let blue = UIColor.blue
        XCTAssertEqual(black.contrastRatio(between: black), 1.0)
        XCTAssertEqual(black.contrastRatio(between: blue)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: black)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: green)!, 6.26, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: red)!, 2.14, accuracy: 0.01)
        XCTAssertEqual(white.contrastRatio(between: white), 1.0)
        XCTAssertEqual(black.contrastRatio(between: white), 21.0)
        XCTAssertEqual(white.contrastRatio(between: black), 21.0)

        let halfGray = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        // sites above give #808080 vs #ffffff a contrast ratio of 3.94
        XCTAssertEqual(halfGray.contrastRatio(between: .white)!, 3.94, accuracy: CGFloat(0.01))
        XCTAssertEqual(halfGray.contrastRatio(between: .black)!, 5.31, accuracy: CGFloat(0.01))
    }

    func testUIColorAverage() {

    }

    func testCGColorLuminance() {

    }

    func testCGColorContrast() {
        let black = CGColor(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        let white = CGColor(srgbRed: 1, green: 1, blue: 1, alpha: 1)
        let red = CGColor(srgbRed: 1, green: 0, blue: 0, alpha: 1)
        let green = CGColor(srgbRed: 0, green: 1, blue: 0, alpha: 1)
        let blue = CGColor(srgbRed: 0, green: 0, blue: 1, alpha: 1)
        XCTAssertEqual(black.contrastRatio(between: black), 1.0)
        XCTAssertEqual(black.contrastRatio(between: blue)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: black)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: green)!, 6.26, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: red)!, 2.14, accuracy: 0.01)
        XCTAssertEqual(white.contrastRatio(between: white), 1.0)
        XCTAssertEqual(black.contrastRatio(between: white), 21.0)
        XCTAssertEqual(white.contrastRatio(between: black), 21.0)

        let halfGray = CGColor(srgbRed: 0.5, green: 0.5, blue: 0.5, alpha: 1)
        // sites above give #808080 vs #ffffff a contrast ratio of 3.94
        XCTAssertEqual(halfGray.contrastRatio(between: white)!, 3.94, accuracy: CGFloat(0.01))
        XCTAssertEqual(halfGray.contrastRatio(between: black)!, 5.31, accuracy: CGFloat(0.01))
    }

    func testCGColorAverage() {

    }

    static var allTests = [
        ("testUIColorLuminance", testUIColorLuminance),
        ("testUIColorContrast", testUIColorContrast),
        ("testUIColorAverage", testUIColorAverage),
        ("testCGColorLuminance", testCGColorLuminance),
        ("testCGColorContrast", testCGColorContrast),
        ("testCGColorAverage", testCGColorAverage),
    ]
}
