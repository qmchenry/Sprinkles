//
//  File.swift
//  
//
//  Created by Quinn McHenry on 8/20/20.
//

import CoreGraphics

extension CGColor {
    var rgba: RGBA {
        guard let components = components else {
            return RGBA(red: 0, green: 0, blue: 0, alpha: 0)
        }
        switch components.count {
        case 4: return RGBA(red: components[0], green: components[1], blue: components[2], alpha: components[3])
        case 3: return RGBA(red: components[0], green: components[1], blue: components[2], alpha: 1)
        case 2: return RGBA(red: components[0], green: components[0], blue: components[0], alpha: components[1])
        default: return RGBA(red: 0, green: 0, blue: 0, alpha: 0)
        }
    }

    var rgbaCapped: RGBA {
        let rgba = self.rgba
        func cap(_ value: CGFloat) -> CGFloat {
            return min(1, max(0, value))
        }
        return RGBA(red: cap(rgba.red), green: cap(rgba.green), blue: cap(rgba.blue), alpha: cap(rgba.alpha))
    }

    public var hex: String {
        let rgba = rgbaCapped
        return String(format: "%02lX%02lX%02lX%02lX",
                      lroundf(Float(rgba.red) * 255),
                      lroundf(Float(rgba.green) * 255),
                      lroundf(Float(rgba.blue) * 255),
                      lroundf(Float(rgba.alpha) * 255))
    }

    func luminance() -> CGFloat? {
        guard let components = components, components.count >= 2 else { return nil }
        return rgba.luminance()
    }

    func contrastRatio(between color: CGColor) -> CGFloat? {
        guard let _ = luminance(), let _ = color.luminance() else { return nil }
        return rgba.contrastRatio(between: color.rgba)
    }

    static func contrastRatio(between color1: CGColor, _ color2: CGColor) -> CGFloat? {
        color1.contrastRatio(between: color2)
    }

    static func average(colors: [CGColor]) -> CGColor? {
        guard colors.count > 0 else { return nil }
        let sumRGBA = colors.map{ $0.rgba }.reduce(RGBA.zero, +)
        let avgRGBA = sumRGBA / CGFloat(colors.count)
        return CGColor(red: avgRGBA.red, green: avgRGBA.green, blue: avgRGBA.blue, alpha: avgRGBA.alpha)
    }
}
