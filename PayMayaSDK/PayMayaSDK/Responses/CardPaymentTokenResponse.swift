////
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

/// Current status of the payment token.
public enum PaymentTokenStatus: String, Decodable {
    
    /// Default value of created payment token
    case available = "AVAILABLE"
    
    /// When the payment is being processed
    case currentlyInUse = "CURRENTLY_IN_USE"
    
    /// When the token has already been used
    case used = "USED"
    
    /// When the token has already expired, and cannot be used
    case expired = "EXPIRED"
    
    /// When the payment is being staged for 3-D Secure payment verification
    case preverification = "PREVERIFICATION"
    
    /// When the payment is being processed for 3-D Secure payment
    case veryfing = "VERYFING"
    
    /// When the payment has already failed 3-D Secure payment verification
    case verificationFailed = "VERIFICATION_FAILED"
}

/// Payment token response.
public struct CardPaymentTokenResponse: Decodable {
    
    /// Payment token id that represents your customer’s credit or debit card details which can be used for payments and customer card addition
    public let paymentTokenId: String
    
    /// Current status of the payment token.
    public let state: PaymentTokenStatus
    
    /// Creation date of the payment token.
    public let createdAt: Date
    
    /// Update date of the payment token.
    public let updatedAt: Date
    
    /// Card issuer
    public let issuer: String
}
