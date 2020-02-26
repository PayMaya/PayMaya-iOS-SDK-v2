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
    let styling: CardPaymentTokenViewStyle
    
    init(action: @escaping (CardDetailsInfo) -> Void, styling: CardPaymentTokenViewStyle) {
        self.buttonAction = action
        self.styling = styling
    }
}

class CardPaymentTokenViewModel {
    let cardNumberModel: CardTextFieldViewModel
    let cvvModel: CVVTextFieldViewModel
    let expirationDateModel: LabeledTextFieldViewModel
    
    private let initialData: CardPaymentTokenInitialData

    private var onEditingChange: OnEditingChange?

    private weak var contract: CardPaymentTokenViewContract? {
        didSet {
            contract?.initialSetup(data: initialData)
        }
    }
        
    init(data: CardPaymentTokenInitialData, onHintTapped: @escaping OnHintTapped) {
        self.initialData = data
        self.cardNumberModel = CardTextFieldViewModel(validator: CardNumberValidator(),
                                                         data: LabeledTextFieldInitData(labelText: "Card Number", styling: data.styling))
        self.cvvModel = CVVTextFieldViewModel(validator: CVCValidator(),
                                                  data: LabeledTextFieldInitData(labelText: "CVV", styling: data.styling), onHintTapped: onHintTapped)
        self.expirationDateModel = LabeledTextFieldViewModel(validator: ExpirationDateValidator(),
                                                             data: LabeledTextFieldInitData(labelText: "Expiry Date",
                                                                                               hint: "MM/YY",
                                                                                               styling: data.styling))
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
                               expYear: String("20" + monthAndYear[1]),
                               cvc: cvvModel.inputText)
    }
    
    func setupModels() {
        expirationDateModel.setExtraDelegate(ExpirationDateFieldDelegate())
        cardNumberModel.setExtraDelegate(CardNumberFieldDelegate())
        cvvModel.setExtraDelegate(CVCFieldDelegate())
        [cardNumberModel, cvvModel, expirationDateModel].forEach({ $0.setOnEditingChanged({ [weak self] in self?.onEditingChanged($0) }) })
    }

    func onEditingChanged(_ valid: Bool) {
        Log.verbose("Input changed, model states:" +
            "cardNumber: valid = \(cardNumberModel.isValid), " +
            "cvvModel: valid = \(cvvModel.isValid), " +
            "expirationDate: valid = \(expirationDateModel.isValid)")
        onEditingChange?(![cardNumberModel, cvvModel, expirationDateModel].map({ $0.isValid }).contains(false))
    }
}
