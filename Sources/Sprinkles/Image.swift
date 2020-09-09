//
//  Image.swift
//
//  A basic representation of image data without CoreGraphics or UIKit dependence
//
//  Created by Quinn McHenry on 9/8/20.
//

import Foundation

struct Image {

    public let data: [RGBA]
    public let width: Int
    public let height: Int

    public var average: RGBA {
        data.count == 0 ? .zero : data.reduce(RGBA.zero, +) / data.count
    }

    public func pixel(x: Int, y: Int) -> RGBA? {
        guard x >= 0, x < width, y >= 0, y < height else { return nil }
        return data[y*width + x]
    }

    public func positions(with color: RGBA) -> [Coordinate] {
        let indices = data.enumerated().filter { $0.element == color }.map { $0.offset }
        return indices.map { Coordinate(x: $0 % width, y: $0 / width) }
    }

    public func remove(colors: [RGBA]) -> [RGBA] {
        var data: [RGBA?] = self.data
        colors.forEach { color in
            let coords = positions(with: color)
            coords.forEach { coord in
                data[coord.x + coord.y * width] = nil
            }
        }
        return data.compactMap { $0 }
    }

    public func remove(color: RGBA) -> [RGBA] {
        remove(colors: [color])
    }

    public init(data: [[RGBA]]) {
        height = data.count
        width = height == 0 ? 0 : data[0].count
        self.data = data.reduce([], +)
    }

    public init(data: [RGBA], width: Int, height: Int) {
        self.data = data
        self.width = width
        self.height = height
    }
}
