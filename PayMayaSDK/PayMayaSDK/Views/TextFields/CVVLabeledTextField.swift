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

import UIKit

class CVVLabeledTextField: LabeledTextField {
    private var hintTapped: OnHintTapped?
    
    init(model: CVVTextFieldViewModel) {
        super.init(model: model)
        setupHintButton()
        hintTapped = model.onHintTapped
        isSecureTextEntry = true
    }
}

private extension CVVLabeledTextField {
    func setupHintButton() {
        let hintButton = UIButton(type: .system)
        let icon = UIImage(named: "info", in: Bundle(for: CardPaymentTokenView.self), compatibleWith: nil) ?? UIImage()
        hintButton.frame = .init(x: 0, y: 0, width: icon.size.width, height: icon.size.height)
        hintButton.setImage(icon, for: .normal)
        hintButton.tintColor = .lightGray
        hintButton.addTarget(self, action: #selector(handleHintTapped), for: .touchUpInside)
        rightViewMode = .always
        rightView = hintButton
    }
    
    @objc func handleHintTapped() {
        if let view = rightView {
            hintTapped?(view)
        }
    }
}
