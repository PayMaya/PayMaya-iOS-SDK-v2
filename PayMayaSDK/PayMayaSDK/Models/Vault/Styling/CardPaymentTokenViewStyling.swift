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
    ///   - buttonStyling: Customization for the pay button
    ///   - font: Font for all texts
    ///   - logo: Optional merchant's logo
    case light(buttonStyling: PayButtonStyling? = nil, font: UIFont? = nil, logo: UIImage? = nil)

    /// Dark mode
    /// - Parameters:
    ///   - buttonStyling: Customization for the pay button
    ///   - font: Font for all texts
    ///   - logo: Optional merchant's logo
    case dark(buttonStyling: PayButtonStyling? = nil, font: UIFont? = nil, logo: UIImage? = nil)
    
    /// Default light mode styling with PayMaya's logo and color
    public static var defaultStyle: CardPaymentTokenViewStyle {
        return .light()
    }
    
    private static var buttonDefaultStyle: PayButtonStyling {
        return PayButtonStyling(title: "Pay Now", backgroundColor: .pmDefault, textColor: .white)
    }
    
    var buttonStyling: PayButtonStyling {
        switch self {
        case .light(let buttonStyling, _, _):
            return buttonStyling ?? Self.buttonDefaultStyle
        case .dark(let buttonStyling, _, _):
            return buttonStyling ?? Self.buttonDefaultStyle
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
