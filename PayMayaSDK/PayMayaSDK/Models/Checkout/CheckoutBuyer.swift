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

public struct CheckoutBuyer: Encodable {
    public let firstName: String
    public let middleName: String
    public let lastName: String
    public let birthday: String
    public let customerSince: String
    public let sex: String
    public let contact: Contact
    public let shippingAddress: ShippingAddress
    public let billingAddress: BillingAddress
    
    public init(firstName: String, middleName: String, lastName: String, birthday: String, customerSince: String, sex: String, contact: Contact, shippingAddress: ShippingAddress, billingAddress: BillingAddress) {
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
