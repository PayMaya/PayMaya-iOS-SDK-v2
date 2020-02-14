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

public enum CardPaymentTokenViewStyle {
    case light(font: UIFont?, logo: UIImage?)
    case dark(font: UIFont?, logo: UIImage?)
    
    var tintColor: UIColor {
        switch self {
        case .light(_):
            return .black
        case .dark(_):
            return .pmGrey
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .light(_):
            return .white
        case .dark(_):
            return .pmBlackBackground
        }
    }
    
    var navbarColor: UIColor {
        switch self {
        case .light(_):
            return UIColor.pmGrey
        case .dark(_):
            return UIColor.pmBlackNavBar
        }
    }
    
    var placeholderColor: UIColor {
        switch self {
        case .light(_):
            return .pmGreyPlaceholder
        case .dark(_):
            return .pmGrey
        }
    }
    
    var font: UIFont {
        let defaultFont = UIFont.systemFont(ofSize: 14)
        switch self {
        case .light(let font, _):
            return font ?? defaultFont
        case .dark(let font, _):
            return font ?? defaultFont
        }
    }
    
    var image: UIImage {
        let defaultImage = UIImage(named: "PMDefaultLogo", in: Bundle(for: CardPaymentTokenView.self), compatibleWith: nil) ?? UIImage()
        switch self {
        case .light(_, let image):
            return image ?? defaultImage
        case .dark(_, let image):
            return image ?? defaultImage
        }
    }
    
    public static var defaultStyle: CardPaymentTokenViewStyle {
        return .light(font: nil, logo: nil)
    }
    
}

private extension UIColor {
    
    static var pmGrey: UIColor {
        return UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0)
    }
    
    static var pmGreyPlaceholder: UIColor {
        return UIColor(red: 205/255, green: 205/255, blue: 205/255, alpha: 0.7)
    }
    
    static var pmBlackNavBar: UIColor {
        return UIColor(red: 42/255, green: 42/255, blue: 42/255, alpha: 1.0)
    }
    
    static var pmBlackBackground: UIColor {
        return UIColor(red: 49/255, green: 49/255, blue: 49/255, alpha: 1.0)
    }
    
}
