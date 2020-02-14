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

/// Represents the entity that can be purchased from a merchant's shop.
public struct CheckoutItem: Encodable {
    
    /// Specifies the item name.
    public let name: String
    
    /// Specifies the number of bought items.
    public let quantity: Int
    
    /// Specifies the merchant assigned SKU code.
    public let code: String?
    
    /// Specifies the item description.
    public let description: String?
    
    /// Specifies the price amount per item.
    public let amount: CheckoutItemAmount?
    
    /// Specifies the total price amount for all the bought items.
    public let totalAmount: CheckoutItemAmount
    
    /// Represents the entity that can be purchased from a merchant's shop.
    /// - Parameters:
    ///   - name: Specifies the item name.
    ///   - quantity: Specifies the number of bought items.
    ///   - code: Specifies the merchant assigned SKU code.
    ///   - description: Specifies the item description.
    ///   - amount: Specifies the price amount per item.
    ///   - totalAmount: Specifies the total price amount for all the bought items.
    public init(name: String,
                quantity: Int,
                code: String? = nil,
                description: String? = nil,
                amount: CheckoutItemAmount? = nil,
                totalAmount: CheckoutItemAmount) {
        self.name = name
        self.quantity = quantity
        self.code = code
        self.description = description
        self.amount = amount
        self.totalAmount = totalAmount
    }
}
