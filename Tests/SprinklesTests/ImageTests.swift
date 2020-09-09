//
//  ImageTests.swift
//  
//
//  Created by Quinn McHenry on 9/8/20.
//


import XCTest
@testable import Sprinkles

final class ImageTests: XCTestCase {

    let black = RGBA(red: 0, green: 0, blue: 0, alpha: 1)
    let white = RGBA(red: 1, green: 1, blue: 1, alpha: 1)
    let red = RGBA(red: 1, green: 0, blue: 0, alpha: 1)
    let green = RGBA(red: 0, green: 1, blue: 0, alpha: 1)
    let blue = RGBA(red: 0, green: 0, blue: 1, alpha: 1)
    let weird = RGBA(red: 0.123, green: 0.987, blue: 0.456, alpha: 0.851)

    func makeImage(width: Int, height: Int, color: RGBA) -> Image {
        let row = Array<RGBA>(repeating: color, count: width)
        let data = Array<[RGBA]>(repeating: row, count: height)
        return Image(data: data)
    }

    func makeRedSpottedImage() -> Image {
        let base = makeImage(width: 10, height: 20, color: white)
        var data = base.data
        data[0] = red
        data[19] = red
        data[20] = red
        data[55] = red
        data[199] = red
        return Image(data: data, width: base.width, height: base.height)
    }

    func testAverage() {
        XCTAssertEqual(makeImage(width: 10, height: 10, color: white).average, white)
        XCTAssertEqual(makeImage(width: 10, height: 10, color: black).average, black)
        XCTAssertEqual(makeImage(width: 10, height: 10, color: red).average, red)
        XCTAssertEqual(makeImage(width: 10, height: 10, color: green).average, green)
        XCTAssertEqual(makeImage(width: 10, height: 10, color: blue).average, blue)
        XCTAssert(makeImage(width: 10, height: 10, color: weird).average ~= weird)
    }

    func testPixelIndicesForColor() {
        let sut = makeRedSpottedImage()
        let indexes = sut.positions(with: red)
        XCTAssertEqual(indexes.count, 5)
        XCTAssertEqual(indexes[0], Coordinate(x: 0, y: 0))
        XCTAssertEqual(indexes[1], Coordinate(x: 9, y: 1))
        XCTAssertEqual(indexes[2], Coordinate(x: 0, y: 2))
        XCTAssertEqual(indexes[3], Coordinate(x: 5, y: 5))
        XCTAssertEqual(indexes[4], Coordinate(x: 9, y: 19))
    }

    func testRemovePixels() {
        let sut = makeRedSpottedImage()
        let redRemoved = sut.remove(colors: [red])
        XCTAssertEqual(redRemoved.count, 195)
        let whiteRemoved = sut.remove(colors: [white])
        XCTAssertEqual(whiteRemoved.count, 5)
        let allRemoved = sut.remove(colors: [white, red])
        XCTAssertEqual(allRemoved.count, 0)
        let blueRemoved = sut.remove(colors: [blue])
        XCTAssertEqual(blueRemoved.count, 200)
    }
}
