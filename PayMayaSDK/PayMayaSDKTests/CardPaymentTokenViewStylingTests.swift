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
import XCTest

@testable import PayMayaSDK

class CardPaymentTokenViewStylingTests: XCTestCase {
    
    func test_givenNoImage_shouldUseFallbackImage() {
        let sut = CardPaymentTokenViewStyling()
        let image = UIImage(named: "PMDefaultLogo", in: Bundle(for: CardPaymentTokenView.self), compatibleWith: nil)
        guard let imgData = image?.pngData(), let defaultData = sut.image.pngData() else {
            XCTFail("No data for images")
            return
        }
        XCTAssertEqual(imgData, defaultData)
    }
    
    func test_givenNoColor_shouldUseBlack() {
        let sut = CardPaymentTokenViewStyling()
        XCTAssertEqual(sut.tintColor, .black)
    }
    
}
