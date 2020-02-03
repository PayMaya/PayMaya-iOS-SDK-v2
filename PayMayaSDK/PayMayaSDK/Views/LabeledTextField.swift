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

class LabeledTextField: UIStackView {
    private var label = UILabel()
    private var textField = UITextField()
   
    private weak var delegate: UITextFieldDelegate?
    private var validator: FieldValidator?
    
    var text: String {
        return textField.text ?? ""
    }
    
    init(labelText: String, tintColor: UIColor) {
        super.init(frame: .zero)
        self.axis = .vertical
        self.distribution = .equalSpacing
        self.alignment = .leading
        self.spacing = 4.0
        setupViews(labelText: labelText, tintColor: tintColor)
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDelegate(_ delegate: UITextFieldDelegate) {
        self.delegate = delegate
    }
    
    func setValidator(_ validator: FieldValidator) {
        self.validator = validator
    }
}

extension LabeledTextField: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        //validate
        //change color to red if wrong
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //validate?
        //change color back to normal
        return true
    }
}

private extension LabeledTextField {
    
    func setupViews(labelText: String, tintColor: UIColor) {
        addSubviews()
        setupLabel(text: labelText, tint: tintColor)
        setupTextField(text: labelText, tint: tintColor)
    }
    
    func addSubviews() {
        self.addArrangedSubview(label)
        self.addArrangedSubview(textField)
    }
    
    func setupLabel(text: String, tint: UIColor) {
        label.text = text
        label.textColor = tint
        label.font = .systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    func setupTextField(text: String, tint: UIColor) {
        textField.textColor = tint
        textField.placeholder = text
        textField.borderStyle = .roundedRect
        textField.tintColor = tint
        textField.keyboardType = .numbersAndPunctuation
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        NSLayoutConstraint.activate([
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            textField.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
}
