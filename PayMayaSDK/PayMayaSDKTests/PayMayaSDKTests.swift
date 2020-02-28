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

class PayMayaSDKTests: XCTestCase {
    
    private var session: NetworkingSpy!

    func setupSDK(withKey: Bool = true) {
        let authKeys: [AuthenticationMethod: String] = [
            .checkout: "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah",
            .payments: "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah",
            .cardToken: "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah"
        ]
        
        PayMayaSDK.setup(environment: .sandbox, authenticationKeys: withKey ? authKeys : [:])
        session = NetworkingSpy()
        PayMayaSDK.session = session
    }

    func test_givenPublicKey_whenCreatesCheckoutPayment_thenSessionGetsEncodedKey() {
        setupSDK()
        PayMayaSDK.presentCheckout(from: ViewControllerSpy(), checkoutInfo: CheckoutInfo.mock) { _ in }
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
            XCTAssertEqual(session?.lastRequestUrl, PayMayaSDK.environment.baseURL + "/payments/v1/payments/\(testCheckoutId)/status")
        }

        session.mockResponseData = """
            {
            "checkoutId": "\(testCheckoutId)",
            "redirectUrl": "https://test.com"
            }
            """.data(using: .utf8)

        let preparedExp = expectation(description: "should get the checkoutId")
        PayMayaSDK.presentCheckout(from: vc, checkoutInfo: CheckoutInfo.mock) { result in
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

        PayMayaSDK.presentCheckout(from: vc, checkoutInfo: CheckoutInfo.mock) { result in
            switch result {
            case .interrupted(let status):
                XCTAssertNil(status)
            default:
                XCTFail("the closure shouldn't get called")
            }
        }
    }
    
    func test_whenCardPaymentCalled_shouldDisplayCardPaymentVC() {
        setupSDK()
        let exp = expectation(description: "Should present proper VC")
        let vc = ViewControllerSpy()
        vc.onPresented = { vc in
            if vc is CardPaymentTokenViewController {
                exp.fulfill()
            }
        }
        PayMayaSDK.presentCardPayment(from: vc) { _ in }
        waitForExpectations(timeout: 0.05, handler: { error in
            XCTAssertNil(error)
        })
    }

    func test_setupEnvironment() {
        PayMayaSDK.setup(environment: .sandbox, authenticationKeys: [:])
        XCTAssertEqual(PayMayaSDK.environment, .sandbox)
        PayMayaSDK.setup(environment: .production, authenticationKeys: [:])
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
        PayMayaSDK.presentCheckout(from: UIViewController(), checkoutInfo: CheckoutInfo.mock) { result in
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
        PayMayaSDK.presentSinglePayment(from: UIViewController(), singlePaymentInfo: SinglePaymentInfo.mock) { result in
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
        PayMayaSDK.presentCreateWalletLink(from: UIViewController(), walletLinkInfo: WalletLinkInfo.mock) { result in
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
        PayMayaSDK.presentCardPayment(from: UIViewController()) { result in
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
