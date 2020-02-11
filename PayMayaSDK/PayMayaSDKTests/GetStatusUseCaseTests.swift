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

class GetStatusUseCaseTests: XCTestCase {

    func test_useCaseResponse_success() {
        let networking = NetworkingSpy()
        
        networking.mockResponseData = """
        {
            "id": "1",
            "status": "PAYMENT_SUCCESS"
        }
        """.data(using: .utf8)
        
        let callbackExp = expectation(description: "Should get callback")
        GetStatusUseCase(session: networking).getStatus(for: "test", authenticationKey: "someKey") { result in
            switch result {
            case .success(let status):
                XCTAssertEqual(status, PaymentStatus.paymentSuccess)
            default:
                XCTFail("Should get success")
            }
            callbackExp.fulfill()
        }
        
        XCTAssertEqual(networking.makeRequestCalled, 1)
        waitForExpectations(timeout: 0.1)
    }
    
    func test_useCaseResponse_failure() {
        let networking = NetworkingSpy()
        
        networking.mockResponseData = """
        {
            "code": "1",
            "message": "Some error"
        }
        """.data(using: .utf8)
        
        let callbackExp = expectation(description: "Should get callback")
        GetStatusUseCase(session: networking).getStatus(for: "test", authenticationKey: "someKey") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "Some error")
            default:
                XCTFail("Should get failure")
            }
            callbackExp.fulfill()
        }
        
        XCTAssertEqual(networking.makeRequestCalled, 1)
        waitForExpectations(timeout: 0.1)
    }
    
    func test_useCaseResponse_error() {
        let networking = NetworkingSpy()
        networking.mockError = NetworkError.unknown
        
        let callbackExp = expectation(description: "Should get callback")
        GetStatusUseCase(session: networking).getStatus(for: "test", authenticationKey: "someKey") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, NetworkError.unknown.localizedDescription)
            default:
                XCTFail("Should get failure")
            }
            callbackExp.fulfill()
        }
        
        XCTAssertEqual(networking.makeRequestCalled, 1)
        waitForExpectations(timeout: 0.1)
    }

}
