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
import UIKit

public enum AuthenticationMethod {
    case checkout
    case payments
    case cardToken
}

public class PayMayaSDK {
    private static var authKeys = [AuthenticationMethod: String]()
    internal static var environment: PayMayaEnvironment = .production
    
    internal static var session: Networking = URLSession.shared

    public static func add(authenticationKey: String, for method: AuthenticationMethod) {
        authKeys[method] = authenticationKey.convertToAuthenticationKey()
        Log.info("Adding authentication key: \(authenticationKey) for method: \(method)")
    }
    
    public static func setup(environment: PayMayaEnvironment, logLevel: LogLevel = .off) {
        self.environment = environment
        Log.logLevel = logLevel
        Log.info("Setting environment: \(environment)")
    }

    public static func checkout(_ checkoutInfo: CheckoutInfo, context: UIViewController, callback: @escaping PaymentCallback) {
        guard let authKey = authKeys[.checkout] else {
            let error = AuthenticationError.missingCheckoutKey
            callback(.error(error))
            Log.error(error.localizedDescription)
            return
        }
        
        let request = CheckoutRequest(checkoutInfo: checkoutInfo, authenticationKey: authKey)
        WebViewPaymentUseCase(session: session,
                              authenticationKey: authKey,
                              request: request,
                              redirectURL: checkoutInfo.redirectUrl,
                              navigationTitle: "PayMaya Checkout",
                              callback: callback)
            .showWebView(context: context)
    }

    public static func singlePayment(_ singlePaymentInfo: SinglePaymentInfo, context: UIViewController, callback: @escaping PaymentCallback) {
        guard let authKey = authKeys[.payments] else {
            let error = AuthenticationError.missingPaymentsKey
            callback(.error(error))
            Log.error(error.localizedDescription)
            return
        }
        
        let request = SinglePaymentRequest(singlePaymentInfo: singlePaymentInfo, authenticationKey: authKey)
        WebViewPaymentUseCase(session: session,
                              authenticationKey: authKey,
                              request: request,
                              redirectURL: singlePaymentInfo.redirectUrl,
                              navigationTitle: "Pay with Paymaya",
                              callback: callback)
            .showWebView(context: context)
    }

    public static func createWallet(_ walletLinkInfo: WalletLinkInfo, context: UIViewController, callback: @escaping PaymentCallback) {
        guard let authKey = authKeys[.payments] else {
            let error = AuthenticationError.missingPaymentsKey
            callback(.error(error))
            Log.error(error.localizedDescription)
            return
        }
        
        let request = CreateWalletLinkRequest(walletLinkInfo: walletLinkInfo, authenticationKey: authKey)
        WebViewPaymentUseCase(session: session,
                              authenticationKey: authKey,
                              request: request,
                              redirectURL: walletLinkInfo.redirectUrl,
                              navigationTitle: "Create Wallet",
                              callback: callback)
            .showWebView(context: context)
    }

    public static func cardPayment(_ context: UIViewController,
                                   styling: CardPaymentTokenViewStyling = CardPaymentTokenViewStyling.defaultStyling,
                                   callback: @escaping (CreateCardResult) -> Void) {
        guard let authKey = authKeys[.cardToken] else {
            callback(.error(AuthenticationError.missingCardTokenKey))
            return
        }
        CardPaymentTokenUseCase(session: session, authenticationKey: authKey).start(context: context, styling: styling, callback: callback)
    }

    public static func getCheckoutStatus(id: String, callback: @escaping StatusCallback) {
        guard let authKey = authKeys[.checkout] else {
            callback(.failure(AuthenticationError.missingCheckoutKey))
            return
        }
        GetStatusUseCase(session: session).getStatus(for: id, authenticationKey: authKey, callback: callback)
    }

    public static func getPaymentStatus(id: String, callback: @escaping StatusCallback) {
        guard let authKey = authKeys[.payments] else {
            callback(.failure(AuthenticationError.missingPaymentsKey))
            return
        }
        GetStatusUseCase(session: session).getStatus(for: id, authenticationKey: authKey, callback: callback)
    }
    
}
