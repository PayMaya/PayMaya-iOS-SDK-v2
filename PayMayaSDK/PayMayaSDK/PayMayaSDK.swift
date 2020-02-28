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

/// Method types for specific public API key
public enum AuthenticationMethod {
    /// For Checkout method
    case checkout
    
    /// For Pay with PayMaya and Create Wallet Link methods
    case payments
    
    /// For Vault Card Payment method
    case cardToken
}

/// Allows you to easily add credit and debit card as payment options to your mobile application.
public class PayMayaSDK {
    private static var authKeys = [AuthenticationMethod: String]()
    internal static var environment: PayMayaEnvironment = .production
    internal static var session: Networking = URLSession.shared
    
    /// Method to initialize the PayMaya SDK with the chosen environment, log level and authentication keys.
    /// - Parameters:
    ///   - environment: The environment to be used by the Payments SDK application
    ///   - logLevel: The log level to be used by the Payments SDK application
    ///   - authenticationKeys: The public-facing API keys given to you for the specified methods
    public static func setup(environment: PayMayaEnvironment,
                             logLevel: LogLevel = .off,
                             authenticationKeys: [AuthenticationMethod: String]) {
        self.environment = environment
        Log.logLevel = logLevel
        Log.info("Setting environment: \(environment)")
        authKeys = authenticationKeys.mapValues { $0.convertToAuthenticationKey() }
        authenticationKeys.forEach { key, value in
            Log.info("Adding authentication key: \(value) for method: \(key)")
        }
    }

    /// Checkout handles the entire purchase process for you. From presenting the input customer's card and billing information to actual purchase transaction execution.
    /// - Parameters:
    ///   - from: The controller on which the checkout process will present itself
    ///   - checkoutInfo: The checkout information details to be processed
    ///   - callback: The result block for the checkout proccess
    public static func presentCheckout(from viewController: UIViewController,
                                       checkoutInfo: CheckoutInfo,
                                       callback: @escaping PaymentCallback) {
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
            .showWebView(context: viewController)
    }
    
    /// Creates a single payment transaction using a PayMaya account.
    /// - Parameters:
    ///   - from: The controller on which the payment process will present itself
    ///   - singlePaymentInfo: The payment information details to be processed
    ///   - callback: The result block for the payment proccess
    public static func presentSinglePayment(from viewController: UIViewController,
                                            singlePaymentInfo: SinglePaymentInfo,
                                            callback: @escaping PaymentCallback) {
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
            .showWebView(context: viewController)
    }
    
    /// Creates a wallet link that allows charging to a PayMaya account.
    /// - Parameters:
    ///   - from: The controller on which the wallet link creation process will present itself
    ///   - walletLinkInfo: The wallet info information details to be processed
    ///   - callback: The result block for the Wallet Link creation proccess
    public static func presentCreateWalletLink(from viewController: UIViewController,
                                               walletLinkInfo: WalletLinkInfo,
                                               callback: @escaping PaymentCallback) {
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
                              withStatusCheck: false,
                              callback: callback)
            .showWebView(context: viewController)
    }
    
    /// This method will present a form to gather user's credit card information and create a paymentToken.
    /// If successful the result will provide a paymentTokenId that will be needed to finalize the payment using your backend.
    /// - Parameters:
    ///   - from: The controller on which the card payment process will present itself
    ///   - styling: Customize styling of the card inputs. Refer to CardPaymentTokenViewStyle for the styling elements that can be changed.
    ///   - callback: The result block for the card payment process
    public static func presentCardPayment(from viewController: UIViewController,
                                   styling: CardPaymentTokenViewStyle = CardPaymentTokenViewStyle.defaultStyle,
                                   callback: @escaping (CreateCardResult) -> Void) {
        guard let authKey = authKeys[.cardToken] else {
            callback(.error(AuthenticationError.missingCardTokenKey))
            return
        }
        CardPaymentTokenUseCase(session: session, authenticationKey: authKey).start(context: viewController, styling: styling, callback: callback)
    }
    
    /// This method will check for the current checkout status of the given id
    /// - Parameters:
    ///   - id: Identifier for the checkout process given in the presentCheckout(from:, checkoutInfo:, callback:) method
    ///   - callback: The result block for the status information
    public static func getCheckoutStatus(id: String, callback: @escaping StatusCallback) {
        guard let authKey = authKeys[.checkout] else {
            callback(.failure(AuthenticationError.missingCheckoutKey))
            return
        }
        GetStatusUseCase(session: session).getStatus(for: id, authenticationKey: authKey, callback: callback)
    }
    
    /// This method will check for the current payment status of the given id
    /// - Parameters:
    ///   - id: Identifier for the Pay with Paymaya process given in the presentSinglePayment(from:, singlePaymentInfo:, callback:) method
    ///   - callback: The result block for the status information
    public static func getPaymentStatus(id: String, callback: @escaping StatusCallback) {
        guard let authKey = authKeys[.payments] else {
            callback(.failure(AuthenticationError.missingPaymentsKey))
            return
        }
        GetStatusUseCase(session: session).getStatus(for: id, authenticationKey: authKey, callback: callback)
    }
    
}
