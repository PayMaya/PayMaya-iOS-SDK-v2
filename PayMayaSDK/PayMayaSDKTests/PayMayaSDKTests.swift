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
    
    private var session: NetworkingSpy!

    func setupSDK(withKey: Bool = true) {
        PayMayaSDK.setup(environment: .sandbox)
        if withKey {
            PayMayaSDK.add(authenticationKey: "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah", for: .checkout)
            PayMayaSDK.add(authenticationKey: "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah", for: .payments)
            PayMayaSDK.add(authenticationKey: "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah", for: .cardToken)
        }
        session = NetworkingSpy()
        PayMayaSDK.session = session
    }

    func test_givenPublicKey_whenCreatesCheckoutPayment_thenSessionGetsEncodedKey() {
        setupSDK()
        PayMayaSDK.checkout(CheckoutInfo.mock, context: ViewControllerSpy()) { result in }
        XCTAssertEqual(session.makeRequestCalled, 1)
        XCTAssertEqual(session.credentials, "Basic cGstWjBPU3pMdkljT0kyVUl2RGhkVEdWVmZSU1NlaUdTdG5jZXF3VUU3bjBBaDo=")
    }
    
    func test_whenWebViewDismissed_afterIdIsSet_makesRequestForStatus() {
        setupSDK()
        let vc = ViewControllerSpy()
        let testCheckoutId = "1234"
        
        vc.onPresented = { [weak session] presentedViewController in
            guard let vc = presentedViewController as? PMWebViewController else {
                XCTFail("wrong view controller is presented")
                return
            }

            vc.onDismiss?()
            XCTAssertEqual(session?.makeRequestCalled, 2)
            XCTAssertEqual(session?.lastRequestUrl, PayMayaSDK.environment.baseURL + "/v1/payments/\(testCheckoutId)/status")
        }

        session.mockResponseData = """
            {
            "checkoutId": "\(testCheckoutId)",
            "redirectUrl": "https://test.com"
            }
            """.data(using: .utf8)

        let preparedExp = expectation(description: "should get the checkoutId")
        PayMayaSDK.checkout(CheckoutInfo.mock, context: vc) { result in
            switch result {
            case .prepared(let id):
                XCTAssertEqual(id, testCheckoutId)
                preparedExp.fulfill()
            default: break
            }
        }
        waitForExpectations(timeout: 0.1)
    }

    func test_whenWebViewDismissed_beforeIdIsSet_doesntMakeStatusRequest() {
        setupSDK()
        let vc = ViewControllerSpy()

        vc.onPresented = { [weak session] presentedViewController in
            guard let vc = presentedViewController as? PMWebViewController else {
                XCTFail("wrong view controller is presented")
                return
            }

            vc.onDismiss?()
            XCTAssertEqual(session?.makeRequestCalled, 1)
            XCTAssertEqual(session?.lastRequestUrl, PayMayaSDK.environment.baseURL + "/checkout/v1/checkouts")
        }

        PayMayaSDK.checkout(CheckoutInfo.mock, context: vc) { _ in
            XCTFail("the closure shouldn't get called")
        }
    }
    
    func test_whenCardPaymentCalled_shouldDisplayCardPaymentVC() {
        setupSDK()
        let vc = ViewControllerSpy()
        vc.onPresented = { vc in
            XCTAssert(vc is CardPaymentTokenViewController)
        }
        PayMayaSDK.cardPayment(vc, callback: { _ in })
    }

    func test_setupEnvironment() {
        PayMayaSDK.setup(environment: .sandbox)
        XCTAssertEqual(PayMayaSDK.environment, .sandbox)
        PayMayaSDK.setup(environment: .production)
        XCTAssertEqual(PayMayaSDK.environment, .production)
    }

    func test_whenGetPaymentStatusCalled_makesRequest() {
        setupSDK()
        PayMayaSDK.getCheckoutStatus(id: "123") { _ in }
        XCTAssertEqual(session.lastRequestUrl, GetStatusRequest(id: "123", authenticationKey: "").url)
        PayMayaSDK.getPaymentStatus(id: "1234") { _ in }
        XCTAssertEqual(session.lastRequestUrl, GetStatusRequest(id: "1234", authenticationKey: "").url)
    }
    
    func test_checkoutCalledWithoutAuthKey_returnsErrorInCallback() {
        setupSDK(withKey: false)
        PayMayaSDK.checkout(CheckoutInfo.mock, context: UIViewController()) { result in
            switch result {
            case .error(let error):
                XCTAssertEqual(error.localizedDescription, AuthenticationError.missingCheckoutKey.localizedDescription)
            default:
                XCTFail("Should get error")
            }
        }
    }

    func test_singlePaymentCalledWithoutAuthKey_returnsErrorInCallback() {
        setupSDK(withKey: false)
        PayMayaSDK.singlePayment(SinglePaymentInfo.mock, context: UIViewController()) { result in
            switch result {
            case .error(let error):
                XCTAssertEqual(error.localizedDescription, AuthenticationError.missingPaymentsKey.localizedDescription)
            default:
                XCTFail("Should get error")
            }
        }
    }
    
    func test_createWalletCalledWithoutAuthKey_returnsErrorInCallback() {
        setupSDK(withKey: false)
        PayMayaSDK.createWallet(WalletLinkInfo.mock, context: UIViewController()) { result in
            switch result {
            case .error(let error):
                XCTAssertEqual(error.localizedDescription, AuthenticationError.missingPaymentsKey.localizedDescription)
            default:
                XCTFail("Should get error")
            }
        }
    }

    func test_addCardCalledWithoutAuthKey_returnsErrorInCallback() {
        setupSDK(withKey: false)
        PayMayaSDK.cardPayment(UIViewController()) { result in
            switch result {
            case .error(let error):
                XCTAssertEqual(error.localizedDescription, AuthenticationError.missingCardTokenKey.localizedDescription)
            default:
                XCTFail("Should get error")
            }
        }
    }

    func test_getCheckoutStatusCalledWithoutAuthKey_returnsErrorInCallback() {
        setupSDK(withKey: false)
        PayMayaSDK.getCheckoutStatus(id: "test") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, AuthenticationError.missingCheckoutKey.localizedDescription)
            default:
                XCTFail("Should get error")
            }
        }
    }

    func test_getPaymentsStatusCalledWithoutAuthKey_returnsErrorInCallback() {
        setupSDK(withKey: false)
        PayMayaSDK.getPaymentStatus(id: "test") { result in
            switch result {
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, AuthenticationError.missingPaymentsKey.localizedDescription)
            default:
                XCTFail("Should get error")
            }
        }
    }

}
