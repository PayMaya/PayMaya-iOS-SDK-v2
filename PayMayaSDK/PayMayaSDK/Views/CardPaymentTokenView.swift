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

public struct CardPaymentTokenViewStyling {
    public var tintColor: UIColor
    public var image: UIImage
    
    public init(tintColor: UIColor? = nil, image: UIImage? = nil) {
        self.tintColor = tintColor ?? .black
        self.image = image ?? UIImage(named: "PMDefaultLogo", in: Bundle(for: CardPaymentTokenView.self), compatibleWith: nil) ?? UIImage()
    }
    
    public static var defaultStyling = CardPaymentTokenViewStyling()
}

private struct Constants {
    static let buttonDefaultConstraint: CGFloat = -16
}

class CardPaymentTokenView: UIView {
    private let cardNumber: LabeledTextField
    private let cvv: LabeledTextField
    private let validityDate: LabeledTextField
    private let imageView: UIImageView
    private let indicatorView = UIActivityIndicatorView(style: .gray)
    
    private let mainStack = UIStackView()
    private let minorStack = UIStackView()
    private let actionButton = UIButton(type: .system)
    
    private let action: (CardDetailsInfo) -> Void
    
    private var buttonConstraint: NSLayoutConstraint?
    
    private var inputData: CardDetailsInfo {
        let monthAndYear = validityDate.text.split(separator: "/")
        return CardDetailsInfo(number: cardNumber.text,
                               expMonth: String(monthAndYear[0]),
                               expYear: String(monthAndYear[1]),
                               cvc: cvv.text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    init(styling: CardPaymentTokenViewStyling, buttonAction: @escaping (CardDetailsInfo) -> Void) {
        cardNumber = LabeledTextField(labelText: "Card Number", tintColor: styling.tintColor)
        cvv = LabeledTextField(labelText: "CVV", tintColor: styling.tintColor)
        validityDate = LabeledTextField(labelText: "Validity", hint: "MM/YYYY", tintColor: styling.tintColor)
        imageView = UIImageView(image: styling.image)
        action = buttonAction
        super.init(frame: .zero)
        setupNotifications()
        setupViews()
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
        
}

private extension CardPaymentTokenView {
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func setupViews() {
        addSubviews()
        setupSelf()
        setupLogo()
        setupMainStack()
        setupMinorStack()
        setupValidators()
        setupButton()
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
    
    func setupSelf() {
        self.backgroundColor = .white
    }
    
    func setupLogo() {
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    func setupMainStack() {
        mainStack.axis = .vertical
        mainStack.distribution = .equalSpacing
        mainStack.spacing = 8
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            mainStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
    }

    func setupMinorStack() {
        minorStack.axis = .horizontal
        minorStack.distribution = .fillEqually
        minorStack.spacing = 16
        
    }
    
    func setupValidators() {
        cardNumber.setValidator(CardNumberValidator())
        cardNumber.setValidityDelegate(self)
        validityDate.setValidator(ExpirationDateValidator())
        validityDate.setCustomDelegate(ExpirationDateFieldDelegate())
        validityDate.setValidityDelegate(self)
        cvv.setValidator(CVCValidator())
        cvv.setValidityDelegate(self)
    }
    
    func setupButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("Add Card", for: .normal)
        addSubview(actionButton)
        self.buttonConstraint = actionButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: Constants.buttonDefaultConstraint)
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
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
        action(inputData)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let size = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        UIView.animate(withDuration: 0.3) { [weak self] in
            self?.buttonConstraint?.constant = Constants.buttonDefaultConstraint - size.height
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

extension CardPaymentTokenView: LabeledTextFieldValidityDelegate {
    func editingDidChange() {
        actionButton.isEnabled = cardNumber.isValid && cvv.isValid && validityDate.isValid
    }
}
