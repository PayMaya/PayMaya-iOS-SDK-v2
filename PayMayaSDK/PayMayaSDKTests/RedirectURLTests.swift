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

    func test_givenRedirectURL_whenCalledStatus_returnProperValue() {
        let success = "https://www.success.com"
        let failure = "https://www.failure.com"
        let cancel = "https://www.cancel.com"
        let redirectURL = RedirectURL(success: success, failure: failure, cancel: cancel)
        
        XCTAssertNotNil(redirectURL)
        
        switch redirectURL?.status(for: success) {
        case .success(let url): XCTAssertEqual(url, success)
        default: XCTFail("wrong case")
        }
        
        switch redirectURL?.status(for: failure) {
        case .failure(let url): XCTAssertEqual(url, failure)
        default: XCTFail("wrong case")
        }
        
        switch redirectURL?.status(for: cancel) {
        case .cancel(let url): XCTAssertEqual(url, cancel)
        default: XCTFail("wrong case")
        }
        
        switch redirectURL?.status(for: "some other url") {
        case .success, .cancel, .failure: XCTFail("wrong case")
        default: break
        }
    }
    
    func test_givenIncorrectRedirectURLWithoutHTTPS_whenCalledStatus_returnsNil() {
        let insecureURL = "http://www.wrongUrl.com"
        let failure = "https://www.failure.com"
        let cancel = "https://www.cancel.com"
        let redirectURL = RedirectURL(success: insecureURL, failure: failure, cancel: cancel)
        
        XCTAssertNil(redirectURL)
    }
    
    func test_givenIncorrectRedirectURLWithFile_whenCalledStatus_returnsNil() {
        let success = "https://www.wrongUrl.com"
        let fileURL = "file://www.failure.com"
        let cancel = "https://www.cancel.com"
        let redirectURL = RedirectURL(success: success, failure: fileURL, cancel: cancel)
        
        XCTAssertNil(redirectURL)
    }

}
