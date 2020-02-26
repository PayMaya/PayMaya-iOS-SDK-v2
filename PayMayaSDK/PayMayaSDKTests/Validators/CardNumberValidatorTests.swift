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

class CardNumberValidatorTests: XCTestCase {
    let validator = CardNumberValidator()
    
    func test_givenCardNumber_whenWrongLength_shouldFail() {
        XCTAssertInvalid(validator.validate(string: "12"))
        XCTAssertInvalid(validator.validate(string: "123451234512345"))
        XCTAssertInvalid(validator.validate(string: "12345123451234512345"))
    }
    
    func test_givenCardNumber_whenWrongChars_shouldFail() {
        XCTAssertInvalid(validator.validate(string: "123451234512345a"))
        XCTAssertInvalid(validator.validate(string: "123451234512345👎"))
        XCTAssertInvalid(validator.validate(string: "123451234512345!"))
    }
    
    func test_givenCardNumber_whenCorrectLength_whenWrongNumber_luhnValidationShouldFail() {
        XCTAssertInvalid(validator.validate(string: "1234512345123451"))
        XCTAssertInvalid(validator.validate(string: "12345123451234512"))
        XCTAssertInvalid(validator.validate(string: "123451234512345123"))
        XCTAssertInvalid(validator.validate(string: "1234512345123451234"))
    }
    
    func test_givenCardNumber_whenCorrectNumber_shouldPass() {
        XCTAssertValid(validator.validate(string: "5123456789012346"))
        XCTAssertValid(validator.validate(string: "5453010000064154"))
        XCTAssertValid(validator.validate(string: "4123450131001381"))
        XCTAssertValid(validator.validate(string: "4123450131001522"))
        XCTAssertValid(validator.validate(string: "4123450131004443"))
        XCTAssertValid(validator.validate(string: "4123450131000508"))
    }
    
    func test_givenInputChar_whenWrong_shouldFail() {
        XCTAssertFalse(validator.isCharAcceptable(char: "a"))
        XCTAssertFalse(validator.isCharAcceptable(char: "!"))
        XCTAssertFalse(validator.isCharAcceptable(char: "*"))
        XCTAssertFalse(validator.isCharAcceptable(char: "😀"))
    }
}
