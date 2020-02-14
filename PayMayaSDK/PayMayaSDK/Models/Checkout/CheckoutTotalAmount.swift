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

/// Gives information about the transaction amount: value, currency, included fees.
public struct CheckoutTotalAmount: Encodable {
    
    /// Specifies the price amount. Value should be numeric.
    public let value: Double
    
    /// Specifies the currency as defined in the ISO standard currency code (http://en.wikipedia.org/wiki/ISO_4217). Value should only be uppercase letters.
    public let currency: String
    
    /// Specifies the amount breakdown.
    public let details: AmountDetails?
    
    /// Gives information about the transaction amount: value, currency, included fees.
    /// - Parameters:
    ///   - value: Specifies the price amount. Value should be numeric.
    ///   - currency: Specifies the currency as defined in the ISO standard currency code (http://en.wikipedia.org/wiki/ISO_4217). Value should only be uppercase letters.
    ///   - details: Specifies the amount breakdown.
    public init(value: Double,
                currency: String,
                details: AmountDetails? = nil) {
        self.value = value
        self.currency = currency
        self.details = details
    }
}
