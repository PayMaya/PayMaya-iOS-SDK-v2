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
import UIKit

enum CardType: String, CaseIterable {
    case visa, mastercard, discover, jcb, amex
    
    static func getType(from string: String) -> CardType? {
        guard !string.isEmpty else { return nil }
        return allCases.compactMap { string.containsPrefixes($0.prefixes) ? $0 : nil }.first
    }
    
    private var prefixes: [PrefixContaining] {
        switch self {
        case .visa: return ["4"]
        case .mastercard: return ["51"..."55", "2221"..."2720"]
        case .discover: return ["6011", "65", "644"..."649", "622126"..."622925"]
        case .jcb: return ["3528"..."3589"]
        case .amex: return ["34", "37"]
        }
    }
    
    var image: UIImage {
        return UIImage(named: self.rawValue, in: Bundle(for: CardPaymentTokenView.self), compatibleWith: nil) ?? UIImage()
    }
}

protocol PrefixContaining {
    func hasCommonPrefix(with text: String) -> Bool
}

extension String: PrefixContaining {
    func hasCommonPrefix(with text: String) -> Bool {
        return hasPrefix(text) || text.hasPrefix(self)
    }
}

extension ClosedRange: PrefixContaining {
    func hasCommonPrefix(with text: String) -> Bool {
        guard let lower = lowerBound as? String, let upper = upperBound as? String else { return false }

        let trimmedRange: ClosedRange<Substring> = {
            let length = text.count
            let trimmedStart = lower.prefix(length)
            let trimmedEnd = upper.prefix(length)
            return trimmedStart...trimmedEnd
        }()

        let trimmedText = text.prefix(trimmedRange.lowerBound.count)
        return trimmedRange ~= trimmedText
    }
}

private extension String {
    func containsPrefixes(_ prefixes: [PrefixContaining]) -> Bool {
        return prefixes.map { $0.hasCommonPrefix(with: self) }.contains(true)
    }
}
