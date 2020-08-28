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
        guard let pixelData = cgImage?.dataProvider?.data,
              let data = CFDataGetBytePtr(pixelData) else { return [] }

        return points.compactMap { point -> UIColor? in
            let index = Int(size.width * point.y + point.x) * 4
            return UIColor(red: CGFloat(data[index]) / 255,
                           green: CGFloat(data[index+1]) / 255,
                           blue: CGFloat(data[index+2]) / 255,
                           alpha: CGFloat(data[index+3]) / 255)
        }
    }

    public var allPoints: [CGPoint] {
        (0..<Int(size.width)).map { xindex -> [CGPoint] in
            (0..<Int(size.height)).map { yindex -> CGPoint in
                CGPoint(x: xindex, y: yindex)
            }
        }.reduce([], +)
    }

    public func averageColor(rect: CGRect? = nil, colorSpace colorSpaceName: CFString = CGColorSpace.sRGB) -> UIColor? {
        let rect = rect ?? CGRect(origin: .zero, size: size)
        guard let bitDepth = cgImage?.bitsPerPixel, bitDepth == 32 || bitDepth == 64 else { return nil }
        guard let inputImage = CIImage(image: self) else { return nil }
        guard let space = CGColorSpace(name: colorSpaceName) else { return nil }

        let extentVector = CIVector(x: rect.origin.x, y: rect.origin.y, z: rect.size.width, w: rect.size.height)
        guard let filter = CIFilter(name: "CIAreaAverage",
                                    parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]),
            let outputImage = filter.outputImage
            else { return nil }

        let format: CIFormat = bitDepth == 32 ? .RGBA8 : .RGBA16
        let context: CIContext = {
            var options = [CIContextOption: Any]()
            options[.workingColorSpace] = space
            options[.workingFormat] = NSNumber(value: format.rawValue)
            return CIContext(options: options)
        }()

        if bitDepth == 64 {
            var bitmap = [UInt16](repeating: 0, count: 4)
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 8,
                           bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: format, colorSpace: space)
            return UIColor(red: CGFloat(bitmap[0])/65535,
                           green: CGFloat(bitmap[1])/65535,
                           blue: CGFloat(bitmap[2])/65535,
                           alpha: CGFloat(bitmap[3])/65535)
        } else {
            var bitmap = [UInt8](repeating: 0, count: 4)
            context.render(outputImage, toBitmap: &bitmap, rowBytes: 4,
                           bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: format, colorSpace: space)
            return UIColor(red: CGFloat(bitmap[0])/255,
                           green: CGFloat(bitmap[1])/255,
                           blue: CGFloat(bitmap[2])/255,
                           alpha: CGFloat(bitmap[3])/255)
        }
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
