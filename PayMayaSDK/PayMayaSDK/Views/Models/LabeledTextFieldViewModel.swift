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

typealias OnEditingChange = (Bool) -> Void

struct LabeledTextFieldInitData {
    let labelText: String
    let hintText: String?
    let styling: CardPaymentTokenViewStyle

    init(labelText: String, hint: String? = nil, styling: CardPaymentTokenViewStyle) {
        self.labelText = labelText
        self.hintText = hint
        self.styling = styling
    }
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
    private var extraDelegate: UITextFieldDelegate?

    private var onEditingChange: OnEditingChange?
    
    var validationState: ValidationState {
        return validator.validate(string: text)
    }
    
    var isValid: Bool {
        return validationState == .valid
    }

    var inputText: String {
        return text.replacingOccurrences(of: " ", with: "")
    }

    var styling: CardPaymentTokenViewStyle {
        return initData.styling
    }

    init(validator: FieldValidator, data: LabeledTextFieldInitData) {
        self.validator = validator
        self.initData = data
    }
    
    func setContract(_ contract: LabeledTextFieldContract) {
        self.contract = contract
    }
    
    func setOnEditingChanged(_ closure: @escaping OnEditingChange) {
        self.onEditingChange = closure
    }
    
    func setExtraDelegate(_ delegate: UITextFieldDelegate) {
        self.extraDelegate = delegate
    }

    func setText(_ text: String) {
        self.text = text
        self.contract?.textSet(text: text)
    }
}

extension LabeledTextFieldViewModel: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        Log.verbose("TextFieldDelegate: editingEnded. Current validation state: \(isValid)")
        contract?.changeValidationState(validationState)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !string.isEmpty else { return extraDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true }
        let isCharAcceptable = !(string.map { validator.isCharAcceptable(char: $0) }.contains(false))
        Log.verbose("TextFieldDelegate: checking character validation returned \(isCharAcceptable)")
        guard isCharAcceptable else { return false }
        return extraDelegate?.textField?(textField, shouldChangeCharactersIn: range, replacementString: string) ?? true
    }

    @objc func editingDidChange(_ textField: LabeledTextField) {
        guard let text = textField.text else {return}
        setText(text)
        onEditingChange?(isValid)
        if !textField.isFirstEdit {
            contract?.changeValidationState(validationState)
        }
    }
}
