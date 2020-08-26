//
//  RGBA.swift
//  
//
//  Created by Quinn McHenry on 8/20/20.
//

import CoreGraphics

public struct RGBA {
    public let red: CGFloat
    public let green: CGFloat
    public let blue: CGFloat
    public let alpha: CGFloat

    /// For the sRGB colorspace, the relative luminance of a color is defined as L = 0.2126 * R + 0.7152 * G + 0.0722 * B where
    /// and B are defined as:
    /// if RsRGB <= 0.03928 then R = RsRGB/12.92 else R = ((RsRGB+0.055)/1.055) ^ 2.4
    /// if GsRGB <= 0.03928 then G = GsRGB/12.92 else G = ((GsRGB+0.055)/1.055) ^ 2.4
    /// if BsRGB <= 0.03928 then B = BsRGB/12.92 else B = ((BsRGB+0.055)/1.055) ^ 2.4
    /// and RsRGB, GsRGB, and BsRGB are defined as:
    /// RsRGB = R8bit/255
    /// GsRGB = G8bit/255
    /// BsRGB = B8bit/255
    /// The "^" character is the exponentiation operator. (Formula taken from [sRGB] and [IEC-4WD]).

    public var luminance: CGFloat {
        // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests
        func luminance(_ component: CGFloat) -> CGFloat {
            return component < 0.03928 ? component / 12.92 : pow((component + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * luminance(red) + 0.7152 * luminance(green) + 0.0722 * luminance(blue)
    }

    // Luminance and contrast ratio computation code from
    // https://stackoverflow.com/questions/42355778/how-to-compute-color-contrast-ratio-between-two-uicolor-instances
    public func contrastRatio(between color: RGBA) -> CGFloat? {
        // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests
        let luminance1 = luminance
        let luminance2 = color.luminance
        let darker = min(luminance1, luminance2)
        let lighter = max(luminance1, luminance2)
        print("lighter: \(lighter) darker: \(darker) CR: \((lighter + 0.05) / (darker + 0.05))")
        return (lighter + 0.05) / (darker + 0.05)
    }

    public static func contrastRatio(between color1: RGBA, _ color2: RGBA) -> CGFloat? {
        color1.contrastRatio(between: color2)
    }

    public var components: [CGFloat] {
        [red, green, blue, alpha]
    }

    public func capped() -> Self {
        func cap(_ value: CGFloat) -> CGFloat {
            return min(1, max(0, value))
        }
        return RGBA(red: cap(red), green: cap(green), blue: cap(blue), alpha: cap(alpha))
    }

    public var hex: String {
        let capped = self.capped()
        return String(format: "%02lX%02lX%02lX%02lX",
                      lroundf(Float(capped.red) * 255),
                      lroundf(Float(capped.green) * 255),
                      lroundf(Float(capped.blue) * 255),
                      lroundf(Float(capped.alpha) * 255))
    }

    public var cgColor: CGColor? {
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }
        return CGColor(colorSpace: colorSpace, components: components)
    }

    public static func +(lhs: RGBA, rhs: RGBA) -> RGBA {
        RGBA(red: lhs.red + rhs.red,
             green: lhs.green + rhs.green,
             blue: lhs.blue + rhs.blue,
             alpha: lhs.alpha + rhs.alpha)
    }

    public static func /(lhs: RGBA, rhs: CGFloat) -> RGBA {
        RGBA(red: lhs.red / rhs, green: lhs.green / rhs, blue: lhs.blue / rhs, alpha: lhs.alpha / rhs)
    }

    public static let zero = RGBA(red: 0, green: 0, blue: 0, alpha: 0)
}

extension RGBA: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.red == rhs.red && lhs.green == rhs.green && lhs.blue == rhs.blue && lhs.alpha == rhs.alpha
    }
}

#if os(iOS)
import UIKit

extension RGBA {
    public var uiColor: UIColor {
        UIColor(rgba: self)
    }
}

#endif
