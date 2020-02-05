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

class ResponsesTests: XCTestCase {
    
    func test_singlePaymentResponse() {
        let json = createJSON(parameterName: "paymentId")
        let response: SinglePaymentResponse? = json?.parseJSON()
        XCTAssertEqual(response?.id, "test")
    }
    
    func test_checkoutResponse() {
        let json = createJSON(parameterName: "checkoutId")
        let response: CheckoutResponse? = json?.parseJSON()
        XCTAssertEqual(response?.id, "test")
    }
    
    func test_createWalletLinkResponse() {
        let json = createJSON(parameterName: "linkId")
        let response: CreateWalletLinkResponse? = json?.parseJSON()
        XCTAssertEqual(response?.id, "test")
    }
}

private extension ResponsesTests {
    func createJSON(parameterName: String) -> Data? {
        return """
        {
            "\(parameterName)": "test",
            "redirectUrl": "https://www.test.com"
        }
        """.data(using: .utf8)
    }
}
