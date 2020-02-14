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

/// Represents the entity that bought items from the merchant's shop.
public struct CheckoutBuyer: Encodable {
    
    /// Specifies the buyer's first name.
    public let firstName: String?
    
    /// Specifies the buyer's middle name.
    public let middleName: String?
    
    /// Specifies the buyer's last name.
    public let lastName: String?
    
    /// Specifies the buyer's birthday. Format YYYY-MM-DD (e.g. "1995-10-24").
    public let birthday: String?
    
    /// Specifies the date when buyer become merchant's customer. Format YYYY-MM-DD (e.g. "1995-10-24").
    public let customerSince: String?
    
    /// Specifies the buyer's gender. M/F.
    public let sex: String?
    
    /// Buyer's contact information.
    public let contact: Contact?
    
    /// Shipping address to be used for the transaction.
    public let shippingAddress: ShippingAddress?
    
    /// Billing address to be used for the transaction.
    public let billingAddress: BillingAddress?
    
    /// Represents the entity that bought items from the merchant's shop.
    /// - Parameters:
    ///   - firstName: Specifies the buyer's first name.
    ///   - middleName: Specifies the buyer's middle name.
    ///   - lastName: Specifies the buyer's last name.
    ///   - birthday: Specifies the buyer's birthday. Format YYYY-MM-DD (e.g. "1995-10-24").
    ///   - customerSince: Specifies the date when buyer become merchant's customer. Format YYYY-MM-DD (e.g. "1995-10-24").
    ///   - sex: Specifies the buyer's gender. M/F.
    ///   - contact: Buyer's contact information.
    ///   - shippingAddress: Shipping address to be used for the transaction.
    ///   - billingAddress: Billing address to be used for the transaction.
    public init(firstName: String? = nil,
                middleName: String? = nil,
                lastName: String? = nil,
                birthday: String? = nil,
                customerSince: String? = nil,
                sex: String? = nil,
                contact: Contact? = nil,
                shippingAddress: ShippingAddress? = nil,
                billingAddress: BillingAddress? = nil) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.birthday = birthday
        self.customerSince = customerSince
        self.sex = sex
        self.contact = contact
        self.shippingAddress = shippingAddress
        self.billingAddress = billingAddress
    }
}
