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

class ExpirationDateFieldDelegate: NSObject, UITextFieldDelegate {
    
    private enum Constants {
        static let maxCharacterCountIncludingSeparator = 5
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else {return true}
        guard let text = textField.text, let textRange = Range(range, in: text) else {return false}
        let updatedText = text.replacingCharacters(in: textRange, with: string)
        guard updatedText.count <= Constants.maxCharacterCountIncludingSeparator else { return false }
        
        if updatedText.count > 1 {
            var formattedText = ""
            updatedText.replacingOccurrences(of: "/", with: "").enumerated().forEach {
                formattedText += String($0.element)
                formattedText += $0.offset == 1 ? "/" : ""
            }
            textField.setText(to: formattedText, preservingCursor: true)
            return false
        }
        
        return true
    }
    
}
