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

/// Details about each line item's amount or total amount
public struct CheckoutItemAmount: Encodable {
    
    /// Payment amount to be charged to the card.
    public let value: Double
    
    /// Breakdown of fees
    public let details: AmountDetails?
    
    /// Details about each line item's amount or total amount
    /// - Parameters:
    ///   - value: Payment amount to be charged to the card.
    ///   - details: Breakdown of fees
    public init(value: Double,
                details: AmountDetails? = nil) {
        self.value = value
        self.details = details
    }
}

extension CheckoutItemAmount: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double

    public init(floatLiteral value: Double) {
        self.value = value
        self.details = nil
    }
}

extension CheckoutItemAmount: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: Int) {
        self.value = Double(value)
        self.details = nil
    }
}
