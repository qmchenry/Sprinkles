//
//  UIImage+Sprinkles.swift
//  
//
//  Created by Quinn McHenry on 8/25/20.
//

#if os(iOS)
import UIKit

extension UIImage {
    public func pixel(at point: CGPoint) -> UIColor? {
        pixels(at: [point]).first
    }

    public func pixels(at points: [CGPoint]) -> [UIColor] {
        guard let cgImage = cgImage else { return [] }
        return cgImage.pixels(at: points).map { $0.uiColor }
    }

    public var allPoints: [CGPoint] {
        (0..<Int(size.width)).map { xindex -> [CGPoint] in
            (0..<Int(size.height)).map { yindex -> CGPoint in
                CGPoint(x: xindex, y: yindex)
            }
        }.reduce([], +)
    }

    public func averageColor(rect: CGRect? = nil, colorSpace colorSpaceName: CFString = CGColorSpace.sRGB) -> UIColor? {
        let resized = resize(CGSize(width: 1, height: 1))
        return resized?.pixels(at: [.zero]).first?.uiColor
    }

    public func resize(_ size: CGSize) -> CGImage? {
        guard let image = cgImage else { return nil }

        let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: image.bitsPerComponent,
                                bytesPerRow: image.bytesPerRow,
                                space: image.colorSpace ?? CGColorSpace(name: CGColorSpace.sRGB)!,
                                bitmapInfo: image.bitmapInfo.rawValue)
        context?.interpolationQuality = .high
        context?.draw(image, in: CGRect(origin: .zero, size: size))

        guard let scaledImage = context?.makeImage() else { return nil }
        return scaledImage
    }

    public func effectiveBackgroundColor() -> UIColor? {
        // The exact corners occasionally returned unexpected colors, potentially due to antialiasing. Sampling a
        // point in from the corners in x and y seems to solve this.
        let xMin = min(1, size.width)
        let yMin = min(1, size.height)
        let xMax = max(size.width - 2, 0)
        let yMax = max(size.height - 2, 0)
        let corners = [
            CGPoint(x: xMin, y: yMin),
            CGPoint(x: xMax, y: yMin),
            CGPoint(x: xMin, y: yMax),
            CGPoint(x: xMax, y: yMax)
        ]
        let colors = pixels(at: corners)
        return UIColor(colors: colors)
    }

    public func crop(to rect: CGRect, viewSize: CGSize) -> UIImage {
        let cropScale = max(size.width/viewSize.width, size.height/viewSize.height) * scale
        let cropRect = CGRect(x: rect.origin.x * cropScale,
                              y: rect.origin.y * cropScale,
                              width: rect.size.width * cropScale,
                              height: rect.size.height * cropScale)
        guard let cropped = cgImage?.cropping(to: cropRect) else {
            return UIImage()
        }
        return UIImage(cgImage: cropped)
    }

    public func crop(to rect: CGRect?, viewSize: CGSize?) -> UIImage? {
        guard let rect = rect, let viewSize = viewSize else { return nil }
        return crop(to: rect, viewSize: viewSize)
    }
}
#endif
