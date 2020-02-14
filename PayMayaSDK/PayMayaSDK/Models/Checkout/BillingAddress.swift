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

/// Billing address of buyer
public struct BillingAddress: Encodable {
    
    /// Specifies the primary address line.
    public let line1: String?
    
    /// Specifies the secondary address line.
    public let line2: String?
    
    /// Specifies the city.
    public let city: String?
    
    /// Specifies the state or province.
    public let state: String?
    
    /// Specifies the postal or zip code e.g. "1605".
    public let zipCode: String?
    
    /// Specifies the country code as defined in the ISO 3166-1 alpha-2 currency code standard (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). Value should only be uppercase letters. Maximum of 2 characters.
    public let countryCode: String?
    
    /// Billing address of buyer
    /// - Parameters:
    ///   - line1: Specifies the primary address line.
    ///   - line2: Specifies the secondary address line.
    ///   - city: Specifies the city.
    ///   - state: Specifies the state or province.
    ///   - zipCode: Specifies the postal or zip code e.g. "1605".
    ///   - countryCode: Specifies the country code as defined in the ISO 3166-1 alpha-2 currency code standard (https://en.wikipedia.org/wiki/ISO_3166-1_alpha-2). Value should only be uppercase letters. Maximum of 2 characters.
    public init(line1: String? = nil,
                line2: String? = nil,
                city: String? = nil,
                state: String? = nil,
                zipCode: String? = nil,
                countryCode: String? = nil) {
        self.line1 = line1
        self.line2 = line2
        self.city = city
        self.state = state
        self.zipCode = zipCode
        self.countryCode = countryCode
    }
}
