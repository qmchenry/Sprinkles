import XCTest
@testable import Sprinkles

final class CGColorTests: XCTestCase {

    let black = RGBA(red: 0, green: 0, blue: 0, alpha: 1).cgColor!
    let white = RGBA(red: 1, green: 1, blue: 1, alpha: 1).cgColor!
    let red = RGBA(red: 1, green: 0, blue: 0, alpha: 1).cgColor!
    let green = RGBA(red: 0, green: 1, blue: 0, alpha: 1).cgColor!
    let blue = RGBA(red: 0, green: 0, blue: 1, alpha: 1).cgColor!
    let halfGray = RGBA(red: 0.5, green: 0.5, blue: 0.5, alpha: 1).cgColor!

    func testCGColorLuminance() {
        XCTAssertEqual(white.luminance(), 1)
        XCTAssertEqual(black.luminance(), 0)
        print(halfGray)
        print(halfGray.luminance()!)
        XCTAssertEqual(halfGray.luminance()!, 0.21586050011389923, accuracy: 0.0000001)
    }

    func testCGColorContrast() {
        XCTAssertEqual(black.contrastRatio(between: black), 1.0)
        XCTAssertEqual(black.contrastRatio(between: blue)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: black)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: green)!, 6.26, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: red)!, 2.14, accuracy: 0.01)
        XCTAssertEqual(white.contrastRatio(between: white), 1.0)
        XCTAssertEqual(black.contrastRatio(between: white), 21.0)
        XCTAssertEqual(white.contrastRatio(between: black), 21.0)

        // sites above give #808080 vs #ffffff a contrast ratio of 3.94
        XCTAssertEqual(halfGray.contrastRatio(between: white)!, 3.94, accuracy: CGFloat(0.01))
        XCTAssertEqual(halfGray.contrastRatio(between: black)!, 5.31, accuracy: CGFloat(0.01))
    }

    func testCGColorAverage() {
        let blackWhiteAvg = CGColor.average(colors: [black, white])!.rgba
        XCTAssertEqual(blackWhiteAvg.red, 0.5)
        XCTAssertEqual(blackWhiteAvg.green, 0.5)
        XCTAssertEqual(blackWhiteAvg.blue, 0.5)
        XCTAssertEqual(blackWhiteAvg.alpha, 1.0)
        let primaryAvg = CGColor.average(colors: [red, green, blue])!.rgba
        XCTAssertEqual(primaryAvg.red, 0.333, accuracy: 0.001)
        XCTAssertEqual(primaryAvg.green, 0.333, accuracy: 0.001)
        XCTAssertEqual(primaryAvg.blue, 0.333, accuracy: 0.001)
        XCTAssertEqual(primaryAvg.alpha, 1.0)
    }

}
