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
import Networking
import UIKit

public enum AuthenticationMethod {
    case checkout
    case payments
    case cardToken
}

public class PayMayaSDK {
    private static var authKeys = [AuthenticationMethod: String]()
    internal static var environment: PayMayaEnvironment = .production
    
    static var session: Networking = URLSession.shared
    
    public static func add(authenticationKey: String, for method: AuthenticationMethod) {
        authKeys[method] = authenticationKey.convertToAuthenticationKey()
    }
    
    public static func setup(environment: PayMayaEnvironment) {
        self.environment = environment
    }

    public static func checkout(_ checkoutInfo: CheckoutInfo, context: UIViewController, callback: @escaping PaymentCallback) {
        guard let authKey = authKeys[.checkout] else {
            callback(.error(AuthenticationError.missingCheckoutKey))
            return
        }

        let request = CheckoutRequest(checkoutInfo: checkoutInfo, authenticationKey: authKey)
        WebViewPaymentUseCase(session: session,
                              request: request,
                              redirectURL: checkoutInfo.redirectUrl,
                              navigationTitle: "PayMaya Checkout")
            .showWebView(context: context, callback: callback)
    }

    public static func singlePayment(_ singlePaymentInfo: SinglePaymentInfo, context: UIViewController, callback: @escaping PaymentCallback) {
        guard let authKey = authKeys[.payments] else {
            callback(.error(AuthenticationError.missingPaymentsKey))
            return
        }

        let request = SinglePaymentRequest(singlePaymentInfo: singlePaymentInfo, authenticationKey: authKey)
        WebViewPaymentUseCase(session: session,
                              request: request,
                              redirectURL: singlePaymentInfo.redirectUrl,
                              navigationTitle: "Pay with Paymaya")
            .showWebView(context: context, callback: callback)
    }

    public static func createWallet(_ walletLinkInfo: WalletLinkInfo, context: UIViewController, callback: @escaping PaymentCallback) {
        guard let authKey = authKeys[.payments] else {
            callback(.error(AuthenticationError.missingPaymentsKey))
            return
        }

        let request = CreateWalletLinkRequest(walletLinkInfo: walletLinkInfo, authenticationKey: authKey)
        WebViewPaymentUseCase(session: session,
                request: request,
                redirectURL: walletLinkInfo.redirectUrl,
                navigationTitle: "Create Wallet")
                .showWebView(context: context, callback: callback)
    }

    public static func addCard(_ context: UIViewController, callback: @escaping (CreateCardResult) -> Void) {
        guard let authKey = authKeys[.cardToken] else {
            callback(.error(AuthenticationError.missingCardTokenKey))
            return
        }
        CardPaymentTokenUseCase(session: session, authenticationKey: authKey).start(context: context, callback: callback)
    }
}
