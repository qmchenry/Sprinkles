# Sprinkles

A colorful framework to make working with colors in Swift happier.

The core purpose of this framework is to compute the contrast ratio between two colors. To support this, additional helper functions compute luminosity and average color. Sprinkles works with UIColor and CGColor and also has functions to get pixel colors and average colors from UIImages.

An RGBA struct performs the luminosity and contrast ratio calculations and Sprikles provides convenience initializers and functions to convert between UIColor/CGColor and RGBA. 

```Swift
import CoreGraphics
import Sprinkles

let white = CGColor.white
let black = CGColor.black
print(black.luminance!) // 0.0
print(white.luminance!) // 1.0
print(white.contrastRatio(between: black)!) // 21.0
```
