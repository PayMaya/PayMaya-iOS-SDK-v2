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

import XCTest
@testable import PayMayaSDK

class CardTypeTests: XCTestCase {
    
    func test_givenProperVisaPrefix_returnsVisa() {
        XCTAssertEqual(CardType.getType(from: "4"), .visa)
        XCTAssertEqual(CardType.getType(from: "456"), .visa)
    }
    
    func test_givenProperJcbPrefix_returnsJcb() {
        XCTAssertEqual(CardType.getType(from: "3580"), .jcb)
        XCTAssertEqual(CardType.getType(from: "3528"), .jcb)
    }
    
    func test_givenProperMastercardPrefix_returnsMastercard() {
        XCTAssertEqual(CardType.getType(from: "54"), .mastercard)
        XCTAssertEqual(CardType.getType(from: "51"), .mastercard)
        XCTAssertEqual(CardType.getType(from: "55"), .mastercard)
        XCTAssertEqual(CardType.getType(from: "2710"), .mastercard)
        XCTAssertEqual(CardType.getType(from: "2720"), .mastercard)
    }
    
    func test_givenProperAmexPrefix_returnsAmex() {
        XCTAssertEqual(CardType.getType(from: "34"), .amex)
        XCTAssertEqual(CardType.getType(from: "37"), .amex)
    }
    
    func test_givenProperDiscoverPrefix_returnsDiscover() {
        XCTAssertEqual(CardType.getType(from: "645"), .discover)
        XCTAssertEqual(CardType.getType(from: "622126"), .discover)
    }
    
    func test_givenNotMatchingPrefixes_retursNil() {
        XCTAssertNil(CardType.getType(from: "36"))
        XCTAssertNil(CardType.getType(from: ""))
        XCTAssertNil(CardType.getType(from: " "))
    }
    
}
