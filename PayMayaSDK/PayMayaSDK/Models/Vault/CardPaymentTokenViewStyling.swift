//
//  Copyright (c) 2020 PayMaya Philippines, Inc.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and
//  associated documentation files (the "Software"), to deal in the Software without restriction,
//  including without limitation the rights to use, copy, modify, merge, publish, distribute,
//  sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT
//  NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import Foundation
import UIKit

/// Customization for the card payment process.
public enum CardPaymentTokenViewStyle {

    /// Light mode
    /// - Parameters:
    ///   - tintColor: Color for the buttons background and textfield accents.
    ///   - font: Font for all texts
    ///   - logo: Optional merchant's logo
    case light(tintColor: UIColor? = nil, font: UIFont? = nil, logo: UIImage? = nil)

    /// Dark mode
    /// - Parameters:
    ///   - tintColor: Color for the buttons background and textfield accents.
    ///   - font: Font for all texts
    ///   - logo: Optional merchant's logo
    case dark(tintColor: UIColor? = nil, font: UIFont? = nil, logo: UIImage? = nil)
    
    /// Default light mode styling with PayMaya's logo and color
    public static var defaultStyle: CardPaymentTokenViewStyle {
        return .light()
    }
    
    var tintColor: UIColor {
        let defaultColor: UIColor = .pmDefault
        switch self {
        case .light(let tintColor, _, _):
            return tintColor ?? defaultColor
        case .dark(let tintColor, _, _):
            return tintColor ?? defaultColor
        }
    }
    
    var inputTextColor: UIColor {
        switch self {
        case .light:
            return .black
        case .dark:
            return .white
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .light:
            return .white
        case .dark:
            return .pmBlackBackground
        }
    }
    
    var navbarColor: UIColor {
        switch self {
        case .light:
            return .pmGrey
        case .dark:
            return .pmBlackNavBar
        }
    }
    
    var placeholderColor: UIColor {
        switch self {
        case .light:
            return .lightGray
        case .dark:
            return .pmGrey
        }
    }
    
    var font: UIFont {
        let defaultFont = UIFont.systemFont(ofSize: 16)
        switch self {
        case .light(_, let font, _):
            return font ?? defaultFont
        case .dark(_, let font, _):
            return font ?? defaultFont
        }
    }
    
    var image: UIImage {
        let defaultImage = UIImage(named: "PMDefaultLogo", in: Bundle(for: CardPaymentTokenView.self), compatibleWith: nil) ?? UIImage()
        switch self {
        case .light(_, _, let image):
            return image ?? defaultImage
        case .dark(_, _, let image):
            return image ?? defaultImage
        }
    }
    
}

private extension UIColor {
    
    static var pmGrey: UIColor {
        return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    }
    
    static var pmDefault: UIColor {
        return UIColor(red: 0.19, green: 0.50, blue: 1.00, alpha: 1.00)
    }
    
    static var pmBlackNavBar: UIColor {
        return UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
    }
    
    static var pmBlackBackground: UIColor {
        return UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1.0)
    }
    
}
