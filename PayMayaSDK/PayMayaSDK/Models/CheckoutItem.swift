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

public struct CheckoutItem: Encodable {
    public let name: String
    public let quantity: Int
    public let code: String
    public let description: String
    public let amount: CheckoutItemAmount
    public let totalAmount: CheckoutItemAmount
    
    public init(name: String, quantity: Int, code: String, description: String, amount: CheckoutItemAmount, totalAmount: CheckoutItemAmount) {
        self.name = name
        self.quantity = quantity
        self.code = code
        self.description = description
        self.amount = amount
        self.totalAmount = totalAmount
    }
}

public struct CheckoutItemAmount: Encodable {
    public let value: Double
    public let details: AmountDetails
    
    public init(value: Double, details: AmountDetails) {
        self.value = value
        self.details = details
    }
}
