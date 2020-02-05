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

struct LabeledTextFieldInitData {
    let labelText: String
    let hintText: String?
    let tintColor: UIColor
    
    init(labelText: String, hint: String? = nil, tintColor: UIColor) {
        self.labelText = labelText
        self.hintText = hint
        self.tintColor = tintColor
    }
}

protocol LabeledTextFieldEditingDelegate: class {
    func editingDidChange(valid: Bool)
}

class LabeledTextFieldViewModel: NSObject {
    private let validator: FieldValidator
    private var text: String = ""
    
    private let initData: LabeledTextFieldInitData
    
    private weak var contract: LabeledTextFieldContract? {
        didSet {
            contract?.initialSetup(data: initData)
        }
    }
    private weak var editingDelegate: LabeledTextFieldEditingDelegate?
    private weak var extraDelegate: UITextFieldDelegate?
    
    var isValid: Bool {
        return validator.validate(string: text)
    }
    
    var inputText: String {
        return text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    init(validator: FieldValidator, styling: LabeledTextFieldInitData) {
        self.validator = validator
        self.initData = styling
    }
    
    func setContract(_ contract: LabeledTextFieldContract) {
        self.contract = contract
    }
    
    func setEndEditingDelegate(_ delegate: LabeledTextFieldEditingDelegate) {
        self.editingDelegate = delegate
    }
    
    func setExtraDelegate(_ delegate: UITextFieldDelegate) {
        self.extraDelegate = delegate
    }
}

extension LabeledTextFieldViewModel: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard let text = textField.text else {return}
        contract?.changeValidationState(valid: validator.validate(string: text), defaultColor: initData.tintColor)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return true }
        return validator.isCharAcceptable(char: Character(string)) &&
            extraDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        contract?.changeValidationState(valid: true, defaultColor: initData.tintColor)
    }
    
    @objc func editingDidChange(_ textField: UITextField) {
        guard let text = textField.text else {return}
        self.text = text
        editingDelegate?.editingDidChange(valid: isValid)
    }
}
