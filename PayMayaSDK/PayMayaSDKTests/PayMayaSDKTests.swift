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
import Networking

@testable import PayMayaSDK

class PayMayaSDKTests: XCTestCase {
    
    func test_givenPublicKey_whenCreatesCheckoutPayment_thenSessionGetsEncodedKey() {
        let publicKey = "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah"
        let session = NetworkingSpy()
        PayMayaSDK.session = session
        PayMayaSDK.setup(publicKey: publicKey, environment: .sandbox)
        PayMayaSDK.checkout(CheckoutInfo.mock, context: MockViewController()) { result in }
        
        XCTAssertEqual(session.makeRequestCalled, 1)
        XCTAssertEqual(session.credentials, "Basic cGstWjBPU3pMdkljT0kyVUl2RGhkVEdWVmZSU1NlaUdTdG5jZXF3VUU3bjBBaDo=")
    }
    
    func test_whenCheckoutCalled_opensWebView() {
        let publicKey = "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah"
        let session = NetworkingSpy()
        PayMayaSDK.session = session
        PayMayaSDK.setup(publicKey: publicKey, environment: .sandbox)
        let vc = MockViewController()
        vc.presentationExp = expectation(description: "the context should be PMWebViewController")
        PayMayaSDK.checkout(CheckoutInfo.mock, context: vc) { result in }
        
        waitForExpectations(timeout: 0.1)
    }

}

private class MockViewController: UIViewController {
    var presentationExp: XCTestExpectation?
    
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if (viewControllerToPresent as? UINavigationController)?.viewControllers.first is PMWebViewController {
            presentationExp?.fulfill()
        }
    }
}

private class NetworkingSpy: Networking {
    var credentials: String? = ""
    var makeRequestCalled = 0
    
    func make<NetworkRequest: Request>(_ request: NetworkRequest, callback: @escaping (NetworkResult<NetworkRequest.Response>) -> Void) {
        credentials = request.headers["Authorization"]
        makeRequestCalled += 1
    }
}
