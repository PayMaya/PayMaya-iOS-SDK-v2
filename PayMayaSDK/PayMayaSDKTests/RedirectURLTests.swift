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

class RedirectURLTests: XCTestCase {

    func test_givenRedirectURL_whenCalledContains_returnProperValue() {
        let redirectURL = RedirectURL(success: "1", failure: "2", cancel: "3")
        
        switch redirectURL.status(for: "1") {
        case .success(let url): XCTAssertEqual(url, "1")
        default: XCTFail("wrong case")
        }
        
        switch redirectURL.status(for: "2") {
        case .failure(let url): XCTAssertEqual(url, "2")
        default: XCTFail("wrong case")
        }
        
        switch redirectURL.status(for: "3") {
        case .cancel(let url): XCTAssertEqual(url, "3")
        default: XCTFail("wrong case")
        }
        
        switch redirectURL.status(for: "4") {
        case .success, .cancel, .failure: XCTFail("wrong case")
        default: break
        }
    }

}
