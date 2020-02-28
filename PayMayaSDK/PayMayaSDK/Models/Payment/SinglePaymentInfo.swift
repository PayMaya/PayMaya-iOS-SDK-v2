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

/// Details about the payment transction
public struct SinglePaymentInfo: Encodable {
    
    /// Total amount details for the transaction.
    public let totalAmount: SinglePaymentTotalAmount
    
    /// List of redirect URLs depending on payment completion status.
    public let redirectUrl: RedirectURL
    
    /// A unique transaction identifier for tracking purposes. By default it will be auto-generated.
    public let requestReferenceNumber: String
    
    /// Merchant provided additional cart information. Optional.
    public let metadata: [String: String]
    
    /// Details about the payment transction
    /// - Parameters:
    ///   - totalAmount: Total amount details for the transaction.
    ///   - redirectUrl: List of redirect URLs depending on payment completion status.
    ///   - requestReferenceNumber: A unique transaction identifier for tracking purposes. By default it will be auto-generated.
    ///   - metadata: Merchant provided additional cart information. Optional.
    public init(totalAmount: SinglePaymentTotalAmount,
                redirectUrl: RedirectURL,
                requestReferenceNumber: String = UUID().uuidString,
                metadata: [String : String] = [:]) {
        self.totalAmount = totalAmount
        self.redirectUrl = redirectUrl
        self.requestReferenceNumber = requestReferenceNumber
        self.metadata = metadata
    }
}
