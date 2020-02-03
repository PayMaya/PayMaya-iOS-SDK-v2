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

class PaymentsView: UIView {
    
    private let singlePaymentButton = PaymentButton(type: .system)
    private let createWalletButton = PaymentButton(type: .system)
    
    private let amountLabel = UILabel()
    private let amountDescriptionLabel = UILabel()
    private let amountBackground = GradientView()
    
    private lazy var amountStack = UIStackView(arrangedSubviews: [amountDescriptionLabel, UIView(), amountLabel])
    private lazy var buttonStack = UIStackView(arrangedSubviews: [singlePaymentButton, createWalletButton])
    
    var payWithPayMayaAction: (() -> Void)?
    var createWalletAction: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(amountBackground)
        addSubview(buttonStack)
        addSubview(amountStack)
        setupView()
    }
    
    func setAmount(_ amount: Double, currencyCode: String) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        amountLabel.text = formatter.string(from: NSNumber(value: amount))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PaymentsView {
    func setupView() {
        setupButtonStack()
        setupAmountLabel()
        setupSinglePaymentButton()
        setupCreateWalletButton()
        setupAmountBackground()
    }
    
    func setupButtonStack() {
        buttonStack.axis = .vertical
        buttonStack.spacing = 16
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: amountBackground.bottomAnchor, constant: 46),
            buttonStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 46),
            buttonStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -46)
        ])
    }
    
    func setupSinglePaymentButton() {
        singlePaymentButton.setTitle("Pay with PayMaya", for: .normal)
        singlePaymentButton.addTarget(self, action: #selector(singlePaymentButtonTapped), for: .touchUpInside)
    }
    
    func setupCreateWalletButton() {
        createWalletButton.setTitle("Create Wallet Link", for: .normal)
        createWalletButton.addTarget(self, action: #selector(createWalletButtonTapped), for: .touchUpInside)
    }
    
    func setupAmountLabel() {
        amountLabel.font = .italicSystemFont(ofSize: 32)
        amountLabel.textColor = .white
        amountDescriptionLabel.textColor = .white
        amountDescriptionLabel.text = "Payment amount: "
        amountDescriptionLabel.font = .boldSystemFont(ofSize: 16)
        
        amountStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 64),
            amountStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            amountStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32)
        ])
    }
    
    func setupAmountBackground() {
        amountBackground.setColors(gradients[3])
        amountBackground.layer.cornerRadius = 10
        amountBackground.layer.masksToBounds = true
        amountBackground.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            amountBackground.topAnchor.constraint(equalTo: amountStack.topAnchor, constant: -24),
            amountBackground.leadingAnchor.constraint(equalTo: amountStack.leadingAnchor, constant: -12),
            amountBackground.trailingAnchor.constraint(equalTo: amountStack.trailingAnchor, constant: 12),
            amountBackground.bottomAnchor.constraint(equalTo: amountStack.bottomAnchor, constant: 24)
        ])
    }
    
    @objc func singlePaymentButtonTapped() {
        payWithPayMayaAction?()
    }
    
    @objc func createWalletButtonTapped() {
        createWalletAction?()
    }
}
