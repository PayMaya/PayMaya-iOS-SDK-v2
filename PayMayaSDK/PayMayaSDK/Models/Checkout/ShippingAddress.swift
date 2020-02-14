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

/// Shipping address of recipient
public struct ShippingAddress: Encodable {
    
    /// Recipient's first name.
    public let firstName: String?
    
    /// Recipient's middle name.
    public let middleName: String?
    
    /// Recipient's last name.
    public let lastName: String?
    
    /// Recipient's phone number e.g. "+(63)1234567890"
    public let phone: String?
    
    /// Recipient's email address e.g. "jdelacruz@sampleonly.com".
    public let email: String?
    
    /// Recipient's primary address line.
    public let line1: String?
    
    /// Recipient's secondary address line.
    public let line2: String?
    
    /// Recipient's city.
    public let city: String?
    
    /// Recipient's state or province.
    public let state: String?
    
    /// Recipient's postal or zip code e.g. "1605".
    public let zipCode: String?
    
    /// Specifies the country code as defined in the ISO 3166-1 alpha-2 currency code standard (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). Value should only be uppercase letters. Maximum of 2 characters.
    public let countryCode: String?
    
    /// Specifies the shipping type. Value should only be uppercase letters. Maximum of 2 characters. ST - for standard, SD - for same day.
    public let shippingType: String?
    
    /// Shipping address of recipient
    /// - Parameters:
    ///   - firstName: Recipient's first name.
    ///   - middleName: Recipient's middle name.
    ///   - lastName: Recipient's last name.
    ///   - phone: Recipient's phone number e.g. "+(63)1234567890"
    ///   - email: Recipient's email address e.g. "jdelacruz@sampleonly.com".
    ///   - line1: Recipient's primary address line.
    ///   - line2: Recipient's secondary address line.
    ///   - city: Recipient's city.
    ///   - state: Recipient's state or province.
    ///   - zipCode: Recipient's postal or zip code e.g. "1605".
    ///   - countryCode: Specifies the country code as defined in the ISO 3166-1 alpha-2 currency code standard (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). Value should only be uppercase letters. Maximum of 2 characters.
    ///   - shippingType: Specifies the shipping type. Value should only be uppercase letters. Maximum of 2 characters. ST - for standard, SD - for same day.
    public init(firstName: String? = nil,
                middleName: String? = nil,
                lastName: String? = nil,
                phone: String? = nil,
                email: String? = nil,
                line1: String? = nil,
                line2: String? = nil,
                city: String? = nil,
                state: String, zipCode: String, countryCode: String, shippingType: String) {
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
