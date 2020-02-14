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

/// When creating a checkout, the merchant can optionally provide these details.
/// If provided, it will reflect to the Checkout Page and will be viewed by the buyer for review.
public struct AmountDetails: Encodable {
    
    /// Discount amount for the transaction.
    public let discount: Double?
    
    /// Service charge amount for the transaction.
    public let serviceCharge: Double?
    
    /// Shipping fee amount for the transaction.
    public let shippingFee: Double?
    
    /// Tax amount for the transaction.
    public let tax: Double?
    
    /// Sum of amounts for all items in the transaction.
    public let subtotal: Double?
    
    /// Gives information about the transaction amount details.
    /// - Parameters:
    ///   - discount: Discount amount for the transaction.
    ///   - serviceCharge: Service charge amount for the transaction.
    ///   - shippingFee: Shipping fee amount for the transaction.
    ///   - tax: Tax amount for the transaction.
    ///   - subtotal: Sum of amounts for all items in the transaction.
    public init(discount: Double? = nil,
                serviceCharge: Double? = nil,
                shippingFee: Double? = nil,
                tax: Double? = nil,
                subtotal: Double? = nil) {
        self.discount = discount
        self.serviceCharge = serviceCharge
        self.shippingFee = shippingFee
        self.tax = tax
        self.subtotal = subtotal
    }
}
