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

protocol LabeledTextFieldContract: class {
    func changeValidationState(valid: Bool, defaultColor: UIColor)
    func initialSetup(data: LabeledTextFieldInitData)
    func textSet(text: String)
}

class LabeledTextField: UITextField {
    
    private enum Constants {
        static let topPadding: CGFloat = 0
        static let spaceBetweenPlaceholderAndText: CGFloat = 8
        static let topPlaceholderPadding: CGFloat = 16
        static let bottomPadding: CGFloat = 8
    }
    
    private let placeholderLayer = CATextLayer()
    private let rightButton = UIButton(type: .system)
    private let lineView = UIView()
    private let errorLabel = UILabel()
    
    private let model: LabeledTextFieldViewModel
    
    private var heightConstraint: NSLayoutConstraint!
    private var currentColor: UIColor = .black
    private var currentFont = UIFont.systemFont(ofSize: 14)
    
    override var text: String? {
        didSet { animatePlaceholder() }
    }
    
    override var placeholder: String? {
        get { placeholderLayer.string as? String }
        set {
            placeholderLayer.string = newValue
            accessibilityLabel = newValue
        }
    }
    
    init(model: LabeledTextFieldViewModel) {
        self.model = model
        super.init(frame: .zero)
        addSubview(lineView)
        addSubview(errorLabel)
        setupView()
        updateFonts()
        setupListeners()
        configure(using: model)
    }
    
    private func configure(using model: LabeledTextFieldViewModel) {
        model.setContract(self)
        errorLabel.text = model.defaultErrorReason
        delegate = model
        isSecureTextEntry = model.isSecure
        if model.hasHint {
            setupRightButton()
        }
        addTarget(model, action: #selector(LabeledTextFieldViewModel.editingDidChange), for: .editingChanged)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return calculateRect(forBounds: bounds)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.rightViewRect(forBounds: bounds)
        return .init(x: rect.origin.x, y: rect.origin.y + Constants.spaceBetweenPlaceholderAndText, width: rect.width, height: rect.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        placeholderLayer.bounds = bounds
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LabeledTextField: LabeledTextFieldContract {
    func changeValidationState(valid: Bool, defaultColor: UIColor) {
        currentColor = valid ? defaultColor : .red
        errorLabel.isHidden = valid
        animatePlaceholder()
    }
    
    func initialSetup(data: LabeledTextFieldInitData) {
        placeholder = data.labelText
        currentColor = data.styling.tintColor
        textColor = data.styling.tintColor
        currentFont = data.styling.font
        updateFonts()
        animatePlaceholder()
    }
    
    func textSet(text: String) {
        self.text = text
    }
}

private extension LabeledTextField {
    func setupView() {
        setupPlaceholder()
        setupLineView()
        setupErrorLabel()
        
        keyboardType = .numberPad
        
        heightConstraint = heightAnchor.constraint(equalToConstant: 0)
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            heightConstraint
        ])
    }
    
      func setupRightButton() {
        let icon = UIImage(named: "info", in: Bundle(for: CardPaymentTokenView.self), compatibleWith: nil) ?? UIImage()
        rightButton.setImage(icon, for: .normal)
        rightButton.tintColor = .lightGray
        rightButton.addTarget(self, action: #selector(handleHintTapped), for: .touchUpInside)
        rightViewMode = .always
        rightView = rightButton
      }
    
    func setupPlaceholder() {
        placeholderLayer.contentsScale = UIScreen.main.scale
        layer.addSublayer(placeholderLayer)
        placeholderLayer.anchorPoint = CGPoint(x: 0, y: 0)
        placeholderLayer.position = CGPoint(x: 0, y: 20)
        placeholderLayer.bounds = placeholderRect(forBounds: bounds)
        animatePlaceholder()
    }
    
    func setupLineView() {
        lineView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lineView.bottomAnchor.constraint(equalTo: bottomAnchor),
            lineView.leadingAnchor.constraint(equalTo: leadingAnchor),
            lineView.trailingAnchor.constraint(equalTo: trailingAnchor),
            lineView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    func setupErrorLabel() {
        errorLabel.isHidden = true
        errorLabel.textColor = .red
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            errorLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            errorLabel.topAnchor.constraint(equalTo: lineView.bottomAnchor, constant: 4),
        ])
    }
    
    func updateFonts() {
        self.font = currentFont
        let errorFont = UIFont.systemFont(ofSize: currentFont.pointSize - 4, weight: .light)
        placeholderLayer.fontSize = currentFont.pointSize
        placeholderLayer.font = font
        self.font = font
        errorLabel.font = errorFont
        heightConstraint.constant = currentFont.pointSize + Constants.topPadding + Constants.topPlaceholderPadding + Constants.spaceBetweenPlaceholderAndText + errorFont.pointSize + Constants.bottomPadding
    }
    
    func setupListeners() {
        addTarget(self, action: #selector(stateDidChange), for: .editingDidEnd)
        addTarget(self, action: #selector(stateDidChange), for: .editingDidBegin)
    }
    
    @objc func handleHintTapped() {
        #warning("TODO in another task")
    }
    
}

private extension LabeledTextField {
    func calculateRect(forBounds bounds: CGRect) -> CGRect {
        let widthPadding: CGFloat = rightButton.frame.width
        let placeholderExpanded = isEditing || text?.isEmpty == false
        let placeholderExpandedYBounds = bounds.origin.y + Constants.spaceBetweenPlaceholderAndText
        let placeholderHiddenYBounds = bounds.origin.y + Constants.topPadding
        let yOrigin = placeholderExpanded ? placeholderExpandedYBounds : placeholderHiddenYBounds
        return CGRect(
            x: leftView?.bounds.maxX ?? bounds.minX,
            y: yOrigin,
            width: bounds.size.width - widthPadding,
            height: bounds.size.height - Constants.topPadding * 2
        )
    }
    
    var isPlaceholderSmall: Bool {
        return isEditing || text?.isEmpty == false
    }
    
    func animatePlaceholder() {
        let placeholderSize = isPlaceholderSmall ? currentFont.pointSize - 2 : currentFont.pointSize
        let yOffset = isPlaceholderSmall ? -Constants.topPlaceholderPadding : placeholderSize / 2
        let placeholderColor: UIColor = isPlaceholderSmall ? currentColor : currentColor == .red ? .red : .lightGray
        let transform = CGAffineTransform(translationX: 0, y: yOffset)
        
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0, options: .curveEaseInOut, animations: { [weak self] in
            self?.placeholderLayer.setAffineTransform(transform)
            self?.placeholderLayer.fontSize = placeholderSize
            self?.placeholderLayer.foregroundColor = placeholderColor.cgColor
            self?.lineView.backgroundColor = placeholderColor
        })
    }
    
    @objc func stateDidChange() {
        animatePlaceholder()
    }
}
