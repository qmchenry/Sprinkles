//
//  File.swift
//  
//
//  Created by Quinn McHenry on 8/20/20.
//

import CoreGraphics

extension CGColor {
    public var rgba: RGBA {
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

    public var rgbaCapped: RGBA {
        rgba.capped()
    }

    public var luminance: CGFloat? {
        guard let components = components, components.count >= 2 else { return nil }
        return rgba.luminance
    }

    public var hex: String {
        return rgba.hex
    }

    public func toColorSpace(name: CFString, intent: CGColorRenderingIntent = .defaultIntent) -> CGColor? {
        guard let colorSpace = CGColorSpace(name: name) else { return nil }
        return converted(to: colorSpace, intent: intent, options: nil)
    }

    public func toColorSpace(colorSpace: CGColorSpace, intent: CGColorRenderingIntent = .defaultIntent) -> CGColor? {
        converted(to: colorSpace, intent: intent, options: nil)
    }

    public var srgb: CGColor? {
        toColorSpace(name: CGColorSpace.sRGB)
    }

    public func contrastRatio(between color: CGColor) -> CGFloat? {
        guard luminance != nil, color.luminance != nil else { return nil }
        return rgba.contrastRatio(between: color.rgba)
    }

    public static func contrastRatio(between color1: CGColor, _ color2: CGColor) -> CGFloat? {
        color1.contrastRatio(between: color2)
    }

    public static func average(colors: [CGColor]) -> CGColor? {
        guard colors.count > 0 else { return nil }
        let sumRGBA = colors.map { $0.rgba }.reduce(RGBA.zero, +)
        let avgRGBA = sumRGBA / CGFloat(colors.count)
        return avgRGBA.cgColor
    }

}
