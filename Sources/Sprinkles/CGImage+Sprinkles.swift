//
//  CGImage+Sprinkles.swift
//  
//
//  Created by Quinn McHenry on 8/28/20.
//

#if canImport(CoreGraphics)
import CoreGraphics

extension CGImage {

    public func pixels(at points: [CGPoint]) -> [RGBA] {
        guard let pixelData = dataProvider?.data,
              let data = CFDataGetBytePtr(pixelData) else { return [] }

        return points.map { point -> RGBA in
            let index = Int(CGFloat(width) * point.y + point.x) * 4
            return RGBA(red: CGFloat(data[index]) / 255,
                        green: CGFloat(data[index+1]) / 255,
                        blue: CGFloat(data[index+2]) / 255,
                        alpha: CGFloat(data[index+3]) / 255)
        }
    }

}

#endif
