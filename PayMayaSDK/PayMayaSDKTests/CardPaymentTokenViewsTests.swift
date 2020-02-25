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
import XCTest
import UIKit

@testable import PayMayaSDK

class CardPaymentTokenViewsTests: XCTestCase {
    
    func testController_whenInitialized_shouldHaveTokenViewAsMainView() {
        let initData = CardPaymentTokenInitialData(action: {_ in}, styling: CardPaymentTokenViewStyle.defaultStyle)
        let sut = CardPaymentTokenViewController(with: initData)
        sut.loadViewIfNeeded()
        XCTAssert(sut.view is CardPaymentTokenView)
    }
        
    func testView_whenCalledEndEditingOnAnySubview_shouldCallEndEditingOnView() {
        let dummyTextField = LabeledTextField(model: LabeledTextFieldViewModel())
        dummyTextField.text = "test"
        let model = CardPaymentTokenViewModel()
        let spy = CardPaymentViewTokenSpy(with: model)
        model.cardNumberModel.editingDidChange(dummyTextField)
        model.cvvModel.editingDidChange(dummyTextField)
        model.expirationDateModel.editingDidChange(dummyTextField)
        XCTAssertEqual(spy.editingDidChangeCalled, 3)
    }
    
    func testView_whenSetContract_shouldCallViewSetupExactlyOnce() {
        let model = CardPaymentTokenViewModel()
        let contract = CardPaymentViewContractSpy()
        model.setContract(contract)
        XCTAssertEqual(contract.setupCalled, 1)
    }
    
    func testLabeledView_whenCalledEndEditing_shouldSetTextOnContract() {
        let model = LabeledTextFieldViewModel()
        let contract = LabeledTextFieldContractSpy()
        let dummyTextField = LabeledTextField(model: model)
        dummyTextField.text = "test"
        model.setContract(contract)
        model.editingDidChange(dummyTextField)
        XCTAssertEqual(contract.textSetCalled, 1)
    }
    
    func testLabeledView_whenSetContract_shouldCallViewSetupExactlyOnce() {
        let model = LabeledTextFieldViewModel()
        let contract = LabeledTextFieldContractSpy()
        model.setContract(contract)
        XCTAssertEqual(contract.setupCalled, 1)
    }
}

private extension CardPaymentTokenViewModel {
    convenience init() {
        self.init(data: CardPaymentTokenInitialData(action: {_ in}, styling: CardPaymentTokenViewStyle.defaultStyle), onHintTapped: {_ in})
    }
}

private extension LabeledTextFieldViewModel {
    convenience override init() {
        self.init(validator: DummyValidator(), data: LabeledTextFieldInitData(labelText: "", styling: CardPaymentTokenViewStyle.defaultStyle))
    }
}
