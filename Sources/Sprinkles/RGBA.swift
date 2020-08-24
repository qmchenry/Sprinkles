//
//  RGBA.swift
//  
//
//  Created by Quinn McHenry on 8/20/20.
//

import CoreGraphics

struct RGBA {
    let red: CGFloat
    let green: CGFloat
    let blue: CGFloat
    let alpha: CGFloat

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

    func luminance() -> CGFloat {
        // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests

        func adjust(_ colorComponent: CGFloat) -> CGFloat {
            return (colorComponent <= CGFloat(0.03928)) ?
                (colorComponent / CGFloat(12.92)) : pow((colorComponent + CGFloat(0.055)) / CGFloat(1.055), CGFloat(2.4))
        }
        return 0.2126 * adjust(red) + 0.7152 * adjust(green) + 0.0722 * adjust(blue)
    }

    // Luminance and contrast ratio computation code from
    // https://stackoverflow.com/questions/42355778/how-to-compute-color-contrast-ratio-between-two-uicolor-instances
    func contrastRatio(between color: RGBA) -> CGFloat? {
        // https://www.w3.org/TR/WCAG20-TECHS/G18.html#G18-tests
        let luminance1 = luminance()
        let luminance2 = color.luminance()
        let darker = min(luminance1, luminance2)
        let lighter = max(luminance1, luminance2)
        return (lighter + 0.05) / (darker + 0.05)
    }

    static func contrastRatio(between color1: RGBA, _ color2: RGBA) -> CGFloat? {
        color1.contrastRatio(between: color2)
    }

    static func +(lhs: RGBA, rhs: RGBA) -> RGBA {
        RGBA(red: lhs.red + rhs.red,
             green: lhs.green + rhs.green,
             blue: lhs.blue + rhs.blue,
             alpha: lhs.alpha + rhs.alpha)
    }

    static func /(lhs: RGBA, rhs: CGFloat) -> RGBA {
        RGBA(red: lhs.red / rhs, green: lhs.green / rhs, blue: lhs.blue / rhs, alpha: lhs.alpha / rhs)
    }

    static let zero = RGBA(red: 0, green: 0, blue: 0, alpha: 0)
}
