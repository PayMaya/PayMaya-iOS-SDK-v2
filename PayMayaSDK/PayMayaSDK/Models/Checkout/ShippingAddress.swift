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

public struct ShippingAddress: Encodable {
    public let firstName: String
    public let middleName: String
    public let lastName: String
    public let phone: String
    public let email: String
    public let line1: String
    public let line2: String
    public let city: String
    public let state: String
    public let zipCode: String
    public let countryCode: String
    public let shippingType: String
    
    public init(firstName: String, middleName: String, lastName: String, phone: String, email: String, line1: String, line2: String, city: String, state: String, zipCode: String, countryCode: String, shippingType: String) {
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.phone = phone
        self.email = email
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.countryCode = countryCode
        self.shippingType = shippingType
    }
}
