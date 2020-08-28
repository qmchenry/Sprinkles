//
//  RBGATests.swift
//  
//
//  Created by Quinn McHenry on 8/26/20.
//

import XCTest
@testable import Sprinkles

final class RBGATests: XCTestCase {

    func testInit() {
        let sut = RGBA(red: -1.0, green: 0.5, blue: 1.333, alpha: 1.0)
        XCTAssertEqual(sut.red, -1.0)
        XCTAssertEqual(sut.green, 0.5)
        XCTAssertEqual(sut.blue, 1.333)
        XCTAssertEqual(sut.alpha, 1.0)
    }

    func testCapped() {
        let sut = RGBA(red: -1.0, green: 0.5, blue: 1.333, alpha: 1.0).capped()
        XCTAssertEqual(sut.red, 0.0)
        XCTAssertEqual(sut.green, 0.5)
        XCTAssertEqual(sut.blue, 1.0)
        XCTAssertEqual(sut.alpha, 1.0)
    }

    func testHex() {
        XCTAssertEqual(RGBA(red: 0x00/255, green: 0x00/255, blue: 0x00/255, alpha: 0x00/255).hex, "00000000")
        XCTAssertEqual(RGBA(red: 0x44/255, green: 0x88/255, blue: 0xbb/255, alpha: 0xff/255).hex, "4488BBFF")
        XCTAssertEqual(RGBA(red: 0x80/255, green: 0x80/255, blue: 0x80/255, alpha: 0x80/255).hex, "80808080")
        XCTAssertEqual(RGBA(red: 0xff/255, green: 0xff/255, blue: 0xff/255, alpha: 0xff/255).hex, "FFFFFFFF")
    }

    let halfGray = RGBA(red: 0x80/255, green: 0x80/255, blue: 0x80/255, alpha: 1.0)

    func testLuminosity() {
        XCTAssertEqual(halfGray.luminance, 0.21586050011389923, accuracy: 0.0000001)
    }

}
