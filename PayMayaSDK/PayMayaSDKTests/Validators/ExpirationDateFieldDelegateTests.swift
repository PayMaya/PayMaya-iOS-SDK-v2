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

class ExpirationDateFieldDelegateTests: XCTestCase {
    
    func test_givenTextFieldInput_whenLessThanTwoChars_shouldReturnTrue() {
        let textToEnter = "1"
        let (result, text) = putTextAndCallDelegate(text: textToEnter)
        XCTAssertEqual(textToEnter, text)
        XCTAssertFalse(text.hasSuffix("/"))
        XCTAssertTrue(result)
    }
    
    func test_givenTextFieldInput_whenMoreThanTwoChars_shouldReturnFalse() {
        let textToEnter = "123"
        let (result, text) = putTextAndCallDelegate(text: textToEnter)
        XCTAssertEqual("12/3", text)
        XCTAssertFalse(result)
    }
    
    func test_givenTextFieldInput_afterTwoChars_shouldPutSlash_andReturnFalse() {
        let textToEnter = "12"
        let (result, text) = putTextAndCallDelegate(text: textToEnter)
        XCTAssertEqual(textToEnter + "/", text)
        XCTAssertFalse(result)
    }
    
    private func putTextAndCallDelegate(text: String) -> (result: Bool, text: String) {
        let delegate = ExpirationDateFieldDelegate()
        let sut = UITextField()
        sut.delegate = delegate
        sut.text = text
        let result = delegate.textField(sut, shouldChangeCharactersIn: NSMakeRange(0, text.count), replacementString: text)
        
        guard let text = sut.text else {
            XCTFail("no text")
            return (false, "")
        }
        return (result, text)
    }
    
}
