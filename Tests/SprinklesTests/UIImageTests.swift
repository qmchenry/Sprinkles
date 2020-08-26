//
//  File.swift
//  
//
//  Created by Quinn McHenry on 8/25/20.
//

import Foundation
import XCTest
@testable import Sprinkles

#if os(iOS)
final class UIImageTests: XCTestCase {

    func testUIImageEffectiveBackgroundColorWhite() {
        let image = loadImage(filename: "white")!
        let rgba = image.effectiveBackgroundColor()!.rgba
        XCTAssertEqual(rgba, UIColor.white.rgba)
    }

    func testUIImageEffectiveBackgroundColorBlack() {
        let image = loadImage(filename: "black")!
        let rgba = image.effectiveBackgroundColor()!.rgba
        XCTAssertEqual(rgba, UIColor.black.rgba)
    }

    func testUIImageEffectiveBackgroundColorWhiteBlack() {
        let image = loadImage(filename: "whiteblack")!
        // colors from four corners:
        // 0.0117647 0.00784314 0.0156863 1
        // 0.0156863 0.0117647 0.00784314 1
        // 0.992157 0.996078 0.996078 1
        // 0.988235 0.996078 0.988235 1
        // which make RBG means of 0.50196075    0.50294096    0.50196061
        let rgba = image.effectiveBackgroundColor()!.rgba
        XCTAssertEqual(rgba.red, 0.5019607, accuracy: 0.000001)
        XCTAssertEqual(rgba.green, 0.50294096, accuracy: 0.000001)
        XCTAssertEqual(rgba.blue, 0.50196061, accuracy: 0.000001)
    }

    func testUIImageAverageColorWhite() {
        let image = loadImage(filename: "white")!
        let allPixels = image.pixels(at: image.allPoints)
        allPixels.forEach { pixel in
            XCTAssertEqual(pixel.rgba, UIColor.white.rgba)
        }

        let average = image.averageColor()!
        print(average)
        XCTAssertEqual(average.rgba, UIColor.white.rgba)
    }

    func testUIImageAverageColorBlack() {
        let image = loadImage(filename: "black")!
        let average = image.averageColor()!
        XCTAssertEqual(average.rgba, UIColor.black.rgba)
    }

    func testUIImageAverageColorWhiteBlack() {
        let image = loadImage(filename: "whiteblack")!
        let average = image.averageColor()!
        print(average)

    }

    func testUIImageGetPixelsWhite() {
        let image = loadImage(filename: "white")!
        let pixels = image.pixels(at: [CGPoint.zero, CGPoint(x: 49, y: 49), CGPoint(x: 99, y: 99)])
        XCTAssertEqual(pixels.count, 3)
        let color = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        XCTAssertEqual(pixels[0], color)
        XCTAssertEqual(pixels[1], color)
        XCTAssertEqual(pixels[2], color)
    }

    func testUIImageGetPixelsBlack() {
        let image = loadImage(filename: "black")!
        let pixels = image.pixels(at: [CGPoint.zero, CGPoint(x: 49, y: 49), CGPoint(x: 99, y: 99)])
        XCTAssertEqual(pixels.count, 3)
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        XCTAssertEqual(pixels[0], color)
        XCTAssertEqual(pixels[1], color)
        XCTAssertEqual(pixels[2], color)
    }

    func testUIImageGetPixels4488bb() {
        let image = loadImage(filename: "4488bb")!
        let pixels = image.pixels(at: [CGPoint.zero, CGPoint(x: 49, y: 49), CGPoint(x: 99, y: 99)])
        XCTAssertEqual(pixels.count, 3)
        let color = UIColor(red: 68/255, green: 136/255, blue: 187/255, alpha: 1)
        XCTAssertEqual(pixels[0], color)
        XCTAssertEqual(pixels[1], color)
        XCTAssertEqual(pixels[2], color)
    }

    func loadImage(filename: String, _ _extension: String = "png") -> UIImage? {
        let bundle = Bundle.module
        guard let path = bundle.path(forResource: filename, ofType: _extension) else { return nil }
        print(path)
        return UIImage(contentsOfFile: path)
    }

}
#endif
