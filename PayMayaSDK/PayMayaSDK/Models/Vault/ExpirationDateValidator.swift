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

class ExpirationDateValidator: FieldValidator {
    func isCharAcceptable(char: Character) -> Bool {
        let customSet = CharacterSet(charactersIn: "1234567890")
        let tempSet = CharacterSet(charactersIn: String(char))
        return tempSet.isSubset(of: customSet)
    }
    
    func validate(string: String) -> ValidationState {
        guard !string.isEmpty else { return .invalid(reason: "Expiry Date is required") }
        let tempSet = CharacterSet(charactersIn: "1234567890/")
        guard CharacterSet(charactersIn: string).isSubset(of: tempSet), let date = date(from: string) else { return .invalid(reason: "Invalid expiry date format") }
        let comparison = Calendar.current.compare(date, to: Date(), toGranularity: .month)
        guard comparison == .orderedDescending || comparison == .orderedSame else { return .invalid(reason: "Card is already expired") }
        return .valid
    }
    
    private func date(from string: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter.date(from: string)
    }
}
