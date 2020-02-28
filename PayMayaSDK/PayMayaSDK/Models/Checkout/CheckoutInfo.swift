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

/// Contains information about the buyer, the items inside the cart, transaction amount, status of payment and other details.
public struct CheckoutInfo: Encodable {
    
    /// Transaction amount details.
    public let totalAmount: CheckoutTotalAmount
    
    /// Customer profile information.
    public let buyer: CheckoutBuyer?
    
    /// List of bought items for the transaction.
    public let items: [CheckoutItem]
    
    /// List of redirect URLs depending on checkout completion status.
    public let redirectUrl: RedirectURL
    
    /// Your unique identifier to a transaction for tracking purposes. By default it will be auto-generated.
    public let requestReferenceNumber: String
    
    /// Merchant provided additional cart information. Optional.
    public let metadata: [String: String]
    
    /// Contains information about the buyer, the items inside the cart, transaction amount, status of payment and other details.
    /// - Parameters:
    ///   - totalAmount: Transaction amount details.
    ///   - buyer: Customer profile information.
    ///   - items: List of bought items for the transaction.
    ///   - redirectUrl: List of redirect URLs depending on checkout completion status.
    ///   - requestReferenceNumber: Your unique identifier to a transaction for tracking purposes. By default it will be auto-generated.
    ///   - metadata: Merchant provided additional cart information. Optional.
    public init(totalAmount: CheckoutTotalAmount,
                buyer: CheckoutBuyer? = nil,
                items: [CheckoutItem],
                redirectUrl: RedirectURL,
                requestReferenceNumber: String = UUID().uuidString,
                metadata: [String: String] = [:]) {
        self.totalAmount = totalAmount
        self.buyer = buyer
        self.items = items
        self.redirectUrl = redirectUrl
        self.requestReferenceNumber = requestReferenceNumber
        self.metadata = metadata
    }
}
