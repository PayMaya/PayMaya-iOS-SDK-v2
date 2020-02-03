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

class CardPaymentTokenView: UIView {
    private let cardNumber: LabeledTextField
    private let cvv: LabeledTextField
    private let validityDate: LabeledTextField
    private let imageView: UIImageView
    
    private let mainStack = UIStackView()
    private let minorStack = UIStackView()
    private let actionButton = UIButton(type: .system)
    
    private let action: (CardDetailsInfo) -> Void
    
    private var inputData: CardDetailsInfo {
        let monthAndYear = validityDate.text.split(separator: "/")
        return CardDetailsInfo(number: cardNumber.text.trimmingCharacters(in: .whitespacesAndNewlines),
                               expMonth: String(monthAndYear[0]).trimmingCharacters(in: .whitespacesAndNewlines),
                               expYear: String(monthAndYear[1]).trimmingCharacters(in: .whitespacesAndNewlines),
                               cvc: cvv.text.trimmingCharacters(in: .whitespacesAndNewlines))
    }
    
    init(styling: CardPaymentTokenViewStyling = CardPaymentTokenViewStyling.defaultStyling, buttonAction: @escaping (CardDetailsInfo) -> Void) {
        cardNumber = LabeledTextField(labelText: "Card Number", tintColor: styling.tintColor)
        cvv = LabeledTextField(labelText: "CVV", tintColor: styling.tintColor)
        validityDate = LabeledTextField(labelText: "Validity", tintColor: styling.tintColor)
        imageView = UIImageView(image: styling.image)
        action = buttonAction
        super.init(frame: .zero)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
}

private extension CardPaymentTokenView {
    func setupViews() {
        addSubviews()
        setupSelf()
        setupLogo()
        setupMainStack()
        setupMinorStack()
        setupButton()
    }
    
    func addSubviews() {
        addSubview(imageView)
        addSubview(mainStack)
        mainStack.addArrangedSubview(cardNumber)
        mainStack.addArrangedSubview(minorStack)
        minorStack.addArrangedSubview(validityDate)
        minorStack.addArrangedSubview(cvv)
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
    
    func setupButton() {
        actionButton.translatesAutoresizingMaskIntoConstraints = false
        actionButton.setTitle("Add Card", for: .normal)
        addSubview(actionButton)
        NSLayoutConstraint.activate([
            actionButton.heightAnchor.constraint(equalToConstant: 50),
            actionButton.widthAnchor.constraint(equalToConstant: 120),
            actionButton.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            actionButton.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
        actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    @objc
    func buttonAction() {
        action(inputData)
    }

}
