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

/// Indicates the state of the payment attached to the transaction.
public enum PaymentStatus: String, Decodable {
    
    case pendingToken = "PENDING_TOKEN"
    
    ///  Initial payment status of the checkout transaction
    case pendingPayment = "PENDING_PAYMENT"
    
    /// When payment transaction is not executed and expiration time has been reached.
    case paymentExpired = "PAYMENT_EXPIRED"
    
    /// When payment transaction is waiting for authentication.
    case forAuthentication = "FOR_AUTHENTICATION"
    
    /// When payment transaction is currently authenticating.
    case authenticating = "AUTHENTICATING"
    
    /// When authentication has been successfully executed. Authentication may be in the form of 3DS authentication for card transactions.
    case authSuccess = "AUTH_SUCCESS"
    
    /// When authentication of payment has failed.
    case authFailed = "AUTH_FAILED"
    
    /// When payment is processing.
    case paymentProcessing = "PAYMENT_PROCESSING"
    
    /// When payment is successfully processed.
    case paymentSuccess = "PAYMENT_SUCCESS"
    
    /// When payment is not successfully processed.
    case paymentFailed = "PAYMENT_FAILED"
    
    /// When a successfully processed payment has been reversed (usually before a settlement cut-off for card-based payments).
    case voided = "VOIDED"
    
    /// When a successfully processed payment has been fully or partially reversed (usually after a settlement cut-off for card-based payments).
    case refunded = "REFUNDED"
}
