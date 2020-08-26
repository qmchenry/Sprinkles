//
//  UIColor+Sprinkles.swift
//
//  Extended functionality for UIColor supporting contrast ratio calculation
//
//  Created by Quinn McHenry on 8/20/20.
//

#if os(iOS)
import UIKit

extension UIColor {
    public var rgba: RGBA {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return RGBA(red: red, green: green, blue: blue, alpha: alpha)
    }

    public convenience init?(colors: [UIColor]) {
        guard colors.count > 0 else { return nil }
        let sumRGBA = colors.map{ $0.rgba }.reduce(RGBA.zero, +)
        let avgRGBA = sumRGBA / CGFloat(colors.count)
        self.init(rgba: avgRGBA)
    }

    public convenience init(rgba: RGBA) {
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }

    public func luminance() -> CGFloat {
        rgba.luminance
    }

    public var hex: String {
        return rgba.hex
    }

    public func toColorSpace(name: CFString, intent: CGColorRenderingIntent = .defaultIntent) -> UIColor? {
        guard let colorSpace = CGColorSpace(name: name) else { return nil }
        return cgColor.converted(to: colorSpace, intent: intent, options: nil)?.uiColor
    }

    public func toColorSpace(colorSpace: CGColorSpace, intent: CGColorRenderingIntent = .defaultIntent) -> UIColor? {
        cgColor.converted(to: colorSpace, intent: intent, options: nil)?.uiColor
    }

    public var srgb: UIColor? {
        cgColor.toColorSpace(name: CGColorSpace.sRGB)?.uiColor
    }

    public func contrastRatio(between color: UIColor) -> CGFloat? {
        rgba.contrastRatio(between: color.rgba)
    }
}

extension CGColor {
    public var uiColor: UIColor {
        UIColor(cgColor: self)
    }
}

#endif
