//
//  UIColor+Sprinkles.swift
//
//  Extended functionality for UIColor supporting contrast ratio calculation
//
//  Created by Quinn McHenry on 8/20/20.
//

import UIKit

extension UIColor {
    var rgba: RGBA {
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
        self.init(red: avgRGBA.red, green: avgRGBA.green, blue: avgRGBA.blue, alpha: avgRGBA.alpha)
    }

    public func contrastRatio(between color: UIColor) -> CGFloat? {
        rgba.contrastRatio(between: color.rgba)
    }
}
