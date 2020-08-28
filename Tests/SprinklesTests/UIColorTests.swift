import XCTest
@testable import Sprinkles

#if os(iOS)
final class UIColorTests: XCTestCase {

    let black = UIColor.black
    let white = UIColor.white
    let red = UIColor.red
    let green = UIColor.green
    let blue = UIColor.blue
    let halfGray = RGBA(red: 0x80/255, green: 0x80/255, blue: 0x80/255, alpha: 1.0).uiColor

    func testUIColorLuminance() {
        XCTAssertEqual(white.luminance, 1)
        XCTAssertEqual(black.luminance, 0)
        XCTAssertEqual(halfGray.luminance!, 0.215, accuracy: 0.001)
    }

    // values from https://webaim.org/resources/contrastchecker/ and https://contrast-ratio.com
    func testUIColorContrast() {
        XCTAssertEqual(black.contrastRatio(between: black), 1.0)
        XCTAssertEqual(black.contrastRatio(between: blue)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: black)!, 2.44, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: green)!, 6.26, accuracy: 0.01)
        XCTAssertEqual(blue.contrastRatio(between: red)!, 2.14, accuracy: 0.01)
        XCTAssertEqual(white.contrastRatio(between: white), 1.0)
        XCTAssertEqual(black.contrastRatio(between: white), 21.0)
        XCTAssertEqual(white.contrastRatio(between: black), 21.0)

        // sites above give #808080 vs #ffffff a contrast ratio of 3.94
        XCTAssertEqual(halfGray.contrastRatio(between: .white)!, 3.94, accuracy: CGFloat(0.01))
        XCTAssertEqual(halfGray.contrastRatio(between: .black)!, 5.31, accuracy: CGFloat(0.01))
    }

    func testUIColorAverage() {
        let blackWhiteAvg = UIColor(colors: [black, white])!.rgba
        XCTAssertEqual(blackWhiteAvg.red, 0.5)
        XCTAssertEqual(blackWhiteAvg.green, 0.5)
        XCTAssertEqual(blackWhiteAvg.blue, 0.5)
        XCTAssertEqual(blackWhiteAvg.alpha, 1.0)
        let primaryAvg = UIColor(colors: [red, green, blue])!.rgba
        XCTAssertEqual(primaryAvg.red, 0.333, accuracy: 0.001)
        XCTAssertEqual(primaryAvg.green, 0.333, accuracy: 0.001)
        XCTAssertEqual(primaryAvg.blue, 0.333, accuracy: 0.001)
        XCTAssertEqual(primaryAvg.alpha, 1.0)
    }

}
#endif
