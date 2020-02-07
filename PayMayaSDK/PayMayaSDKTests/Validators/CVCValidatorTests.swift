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

class CVCValidatorTests: XCTestCase {
    let validator = CVCValidator()
    
    func test_givenCVCnumber_whenWrongLength_shouldFail() {
        XCTAssertFalse(validator.validate(string: "12"))
        XCTAssertFalse(validator.validate(string: "1"))
        XCTAssertFalse(validator.validate(string: ""))
        XCTAssertFalse(validator.validate(string: "12345"))
        XCTAssertFalse(validator.validate(string: "123456"))
    }
    
    func test_givenCVCnumber_whenWrongChars_shouldFail() {
        XCTAssertFalse(validator.validate(string: "test"))
        XCTAssertFalse(validator.validate(string: "11a"))
        XCTAssertFalse(validator.validate(string: "test"))
        XCTAssertFalse(validator.validate(string: "12/"))
        XCTAssertFalse(validator.validate(string: "*&^"))
        XCTAssertFalse(validator.validate(string: "🍎👍🤖👎"))
    }
    
    func test_givenCVCnumber_whenCorrectChars_shouldPass() {
        XCTAssertTrue(validator.validate(string: "123"))
        XCTAssertTrue(validator.validate(string: "0000"))
    }
    
    func test_givenInputChar_whenWrong_shouldFail() {
        XCTAssertFalse(validator.isCharAcceptable(char: "a"))
        XCTAssertFalse(validator.isCharAcceptable(char: "!"))
        XCTAssertFalse(validator.isCharAcceptable(char: "*"))
        XCTAssertFalse(validator.isCharAcceptable(char: "😀"))
    }
}
