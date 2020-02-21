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
    case checkout
    case payments
    case cardToken
}

public class PayMayaSDK {
    private static var authKeys = [AuthenticationMethod: String]()
    internal static var environment: PayMayaEnvironment = .production
    internal static var session: Networking = URLSession.shared

    /// Method to add the user's public API key the PayMaya SDK for different methods.
    /// Refer to AuthenticationMethod for the different methods that can be used.
    /// - Parameters:
    ///   - authenticationKey: The public-facing API key given to you for the specified method
    ///   - method: The method that will be using th API key
    public static func add(authenticationKey: String, for method: AuthenticationMethod) {
        authKeys[method] = authenticationKey.convertToAuthenticationKey()
        Log.info("Adding authentication key: \(authenticationKey) for method: \(method)")
    }
    
    /// Method to initialize the PayMaya SDK with the chosen environment and log level.
    /// - Parameters:
    ///   - environment: The environment to be used by the Payments SDK application
    ///   - logLevel: The log level to be used by the Payments SDK application
    public static func setup(environment: PayMayaEnvironment, logLevel: LogLevel = .off) {
        self.environment = environment
        Log.logLevel = logLevel
        Log.info("Setting environment: \(environment)")
    }

    /// This method will present a view controller where the customer can complete the whole checkout process.
    /// - Parameters:
    ///   - checkoutInfo: The checkout information details to be processed
    ///   - context: The context on which the view controller will present itself
    ///   - callback: The result block for the checkout proccess
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
    
    /// This method will present a view controller where the customer can complete the whole Pay with PayMaya process.
    /// - Parameters:
    ///   - singlePaymentInfo: The payment information details to be processed
    ///   - context: The context on which the view controller will present itself
    ///   - callback: The result block for the payment proccess
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
    
    /// This method will present a view controller where the customer can complete the creating Wallet Link process.
    /// - Parameters:
    ///   - walletLinkInfo: The wallet info information details to be processed
    ///   - context: The context on which the view controller will present itself.
    ///   - callback: The result block for the Wallet Link creation proccess
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
    
    /// This method will present a view controller where the customer can complete the card payment process.
    /// - Parameters:
    ///   - context: The context on which the view controller will present itself
    ///   - styling: Customize styling of the card inputs. Refer to CardPaymentTokenViewStyle for the styling elements that can be changed.
    ///   - callback: The result block for the card payment process
    public static func cardPayment(_ context: UIViewController,
                                   styling: CardPaymentTokenViewStyle = CardPaymentTokenViewStyle.defaultStyle,
                                   callback: @escaping (CreateCardResult) -> Void) {
        guard let authKey = authKeys[.cardToken] else {
            callback(.error(AuthenticationError.missingCardTokenKey))
            return
        }
        CardPaymentTokenUseCase(session: session, authenticationKey: authKey).start(context: context, styling: styling, callback: callback)
    }
    
    /// This method will check for the current checkout status of the given id
    /// - Parameters:
    ///   - id: Identifier for the checkout process given in the checkout(_:, context:, callback:) method
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
    ///   - id: Identifier for the Pay with Paymaya process given in the singlePayment(_:, context:, callback:) method
    ///   - callback: The result block for the status information
    public static func getPaymentStatus(id: String, callback: @escaping StatusCallback) {
        guard let authKey = authKeys[.payments] else {
            callback(.failure(AuthenticationError.missingPaymentsKey))
            return
        }
        GetStatusUseCase(session: session).getStatus(for: id, authenticationKey: authKey, callback: callback)
    }
    
}
