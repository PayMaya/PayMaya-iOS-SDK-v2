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

private struct Constants {
    static let buttonDefaultConstraint: CGFloat = -16
}

protocol CardPaymentTokenViewContract: class {
    func initialSetup(data: CardPaymentTokenInitialData)
}

class CardPaymentTokenView: UIView {
    private let cardNumber: LabeledTextField
    private let cvv: CVVLabeledTextField
    private let validityDate: LabeledTextField

    private let imageView = UIImageView()
    private let indicatorView = UIActivityIndicatorView(style: .gray)
    
    private let mainStack = UIStackView()
    private let minorStack = UIStackView()
    private let actionButton = RoundButton(type: .system)
    
    private let model: CardPaymentTokenViewModel

    private var buttonConstraint: NSLayoutConstraint?

    init(with model: CardPaymentTokenViewModel) {
        self.model = model
        self.cardNumber = CardLabeledTextField(model: model.cardNumberModel)
        self.cvv = CVVLabeledTextField(model: model.cvvModel)
        self.validityDate = LabeledTextField(model: model.expirationDateModel)
        super.init(frame: .zero)
        model.setContract(self)
        model.setOnEditingChanged({ [weak self] in self?.onEditingChanged($0) })
        setupNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func hideActivityIndicator() {
        indicatorView.isHidden = true
    }
    
    func onEditingChanged(_ valid: Bool) {
        actionButton.isEnabled = valid
    }
        
}

extension CardPaymentTokenView: CardPaymentTokenViewContract {
    func initialSetup(data: CardPaymentTokenInitialData) {
        setupViews(with: data)
    }
}

private extension CardPaymentTokenView {
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupViews(with data: CardPaymentTokenInitialData) {
        addSubviews()
        setupSelf(with: data.styling)
        setupLogo(with: data.styling.image)
        setupMainStack()
        setupMinorStack()
        setupButton(with: data.styling)
        setupActivityIndicator()
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(mainStack)
        mainStack.addArrangedSubview(cardNumber)
        mainStack.addArrangedSubview(minorStack)
        minorStack.addArrangedSubview(validityDate)
        minorStack.addArrangedSubview(cvv)
        addSubview(indicatorView)
    }
    
    func setupSelf(with styling: CardPaymentTokenViewStyle) {
        self.backgroundColor = styling.backgroundColor
    }
    
    func setupLogo(with image: UIImage) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 32),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -32),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.height / 5),
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    func setupMainStack() {
        mainStack.axis = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 16
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: UIDevice.current.isSmall ? 8 : 16),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
    }

    func setupMinorStack() {
        minorStack.axis = .horizontal
        minorStack.distribution = .fillEqually
        minorStack.spacing = 16
    }
    
    func setupButton(with styling: CardPaymentTokenViewStyle) {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.backgroundColor = styling.buttonStyling.backgroundColor
        actionButton.setTitleColor(styling.buttonStyling.textColor, for: .normal)
        actionButton.titleLabel?.font = styling.font
        actionButton.setTitle(styling.buttonStyling.title, for: .normal)
        addSubview(actionButton)
        self.buttonConstraint = actionButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonDefaultConstraint)
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: UIDevice.current.isSmall ? 44 : 50),
            actionButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            actionButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            actionButton.topAnchor.constraint(greaterThanOrEqualTo: minorStack.bottomAnchor, constant: UIDevice.current.isSmall ? 32 : 48),
            buttonConstraint!,
            actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        actionButton.isEnabled = false
    }
    
    func setupActivityIndicator() {
        indicatorView.isHidden = true
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    @objc func buttonAction() {
        self.endEditing(true)
        indicatorView.isHidden = false
        indicatorView.startAnimating()
        model.buttonPressed()
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let size = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.buttonConstraint?.constant = Constants.buttonDefaultConstraint - size.height + (UIDevice.current.isSmall ? 8 : 0)
            self?.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.buttonConstraint?.constant = Constants.buttonDefaultConstraint
            self?.layoutIfNeeded()
        }
    }
}
