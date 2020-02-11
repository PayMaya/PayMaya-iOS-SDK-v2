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

struct CardPaymentTokenInitialData {
    let buttonAction: (CardDetailsInfo) -> Void
    let styling: CardPaymentTokenViewStyling
    
    init(action: @escaping (CardDetailsInfo) -> Void, styling: CardPaymentTokenViewStyling) {
        self.buttonAction = action
        self.styling = styling
    }
}

class CardPaymentTokenViewModel {
    let cardNumberModel: LabeledTextFieldViewModel
    let cvvModel: LabeledTextFieldViewModel
    let expirationDateModel: LabeledTextFieldViewModel
    
    private let initialData: CardPaymentTokenInitialData

    private var onEditingChange: OnEditingChange?

    private weak var contract: CardPaymentTokenViewContract? {
        didSet {
            contract?.initialSetup(data: initialData)
        }
    }
        
    init(data: CardPaymentTokenInitialData) {
        self.initialData = data
        self.cardNumberModel = LabeledTextFieldViewModel(validator: CardNumberValidator(),
                                                         styling: LabeledTextFieldInitData(labelText: "Card Number", tintColor: data.styling.tintColor))
        self.cvvModel = LabeledTextFieldViewModel(validator: CVCValidator(),
                                                  styling: LabeledTextFieldInitData(labelText: "CVV", tintColor: data.styling.tintColor))
        self.expirationDateModel = LabeledTextFieldViewModel(validator: ExpirationDateValidator(),
                                                             styling: LabeledTextFieldInitData(labelText: "Validity",
                                                                                               hint: "MM/YYYY",
                                                                                               tintColor: data.styling.tintColor))
        setupModels()
    }
    
    func setContract(_ contract: CardPaymentTokenViewContract) {
        self.contract = contract
    }
    
    func setOnEditingChanged(_ closure: @escaping OnEditingChange) {
        self.onEditingChange = closure
    }
    
    func buttonPressed() {
        initialData.buttonAction(inputData)
    }
    
}


private extension CardPaymentTokenViewModel {
    private var inputData: CardDetailsInfo {
        let monthAndYear = expirationDateModel.inputText.split(separator: "/")
        return CardDetailsInfo(number: cardNumberModel.inputText,
                               expMonth: String(monthAndYear[0]),
                               expYear: String(monthAndYear[1]),
                               cvc: cvvModel.inputText)
    }
    
    func setupModels() {
        expirationDateModel.setExtraDelegate(ExpirationDateFieldDelegate())
        [cardNumberModel, cvvModel, expirationDateModel].forEach({ $0.setOnEditingChanged(self.onEditingChanged(_:)) })
    }

    func onEditingChanged(_ valid: Bool) {
        onEditingChange?(![cardNumberModel, cvvModel, expirationDateModel].map({ $0.isValid }).contains(false))
    }
}
