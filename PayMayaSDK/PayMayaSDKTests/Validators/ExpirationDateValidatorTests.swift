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

class ExpirationDateValidatorTest: XCTestCase {
    let validator = ExpirationDateValidator()

    func test_givenString_whenNotDate_shouldFail() {
        XCTAssertInvalid(validator.validate(string: "test"))
        XCTAssertInvalid(validator.validate(string: "MAR/2020"))
        XCTAssertInvalid(validator.validate(string: "current"))
        XCTAssertInvalid(validator.validate(string: "!!!"))
        XCTAssertInvalid(validator.validate(string: "test"))
    }
    
    func test_givenDate_whenWrongDate_shouldFail() {
        XCTAssertInvalid(validator.validate(string: "18/2020"))
        XCTAssertInvalid(validator.validate(string: "00/00"))
    }
    
    func test_givenDate_whenDateHasPassed_shouldFail() {
        XCTAssertInvalid(validator.validate(string: "1/2020"))
        XCTAssertInvalid(validator.validate(string: "7/1990"))
    }
    
    func test_givenDate_whenCorrect_shouldPass() {
        XCTAssertValid(validator.validate(string: "12/2022"))
        XCTAssertValid(validator.validate(string: currentDateFormattedAdding(months: 0)))
        XCTAssertValid(validator.validate(string: currentDateFormattedAdding(months: 5)))
        XCTAssertValid(validator.validate(string: "1/2025"))
    }
    
    func test_givenInputChar_whenWrong_shouldFail() {
        XCTAssertFalse(validator.isCharAcceptable(char: "a"))
        XCTAssertFalse(validator.isCharAcceptable(char: "!"))
        XCTAssertFalse(validator.isCharAcceptable(char: "*"))
        XCTAssertFalse(validator.isCharAcceptable(char: "😀"))
    }
    
    func test_givenInputChar_whenCorrect_shouldPass() {
        XCTAssertTrue(validator.isCharAcceptable(char: "1"))
    }
    
    private func currentDateFormattedAdding(months: Int) -> String {
        let current = Date()
        var dateComponents = DateComponents()
        dateComponents.setValue(1, for: .month)
        let newDate = Calendar.current.date(byAdding: dateComponents, to: current)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/YYYY"
        return formatter.string(from: newDate!)
    }
    
}
