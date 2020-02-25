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

@testable import PayMayaSDK

class CardPaymentTokenViewModelsTests: XCTestCase {
    
    func test_givenSampleData_shouldReturnThisDataInCallback() {
        let exp = expectation(description: "Should call callback and return proper values")
        let mock = CallbackMock(exp: exp)
        let initData = CardPaymentTokenInitialData(action: mock.callback(_:), styling: CardPaymentTokenViewStyle.defaultStyle)
        _ = CardTokenViewModelMock(data: initData, onHintTapped: { _ in })
        waitForExpectations(timeout: 0.01, handler: { error in
            XCTAssertNil(error)
        })
    }
    
}

private class CallbackMock {
    let exp: XCTestExpectation
    
    init(exp: XCTestExpectation) {
        self.exp = exp
    }
    
    func callback(_ data: CardDetailsInfo) {
        XCTAssertEqual(data.cvc, "111")
        XCTAssertEqual(data.number, "123123123")
        XCTAssertEqual(data.expMonth, "12")
        XCTAssertEqual(data.expYear, "2022")
        exp.fulfill()
    }
}

private class CardTokenViewModelMock: CardPaymentTokenViewModel {
    
    override init(data: CardPaymentTokenInitialData, onHintTapped: @escaping OnHintTapped) {
        super.init(data: data, onHintTapped: onHintTapped)
        cardNumberModel.setText("123123123")
        cvvModel.setText("111")
        expirationDateModel.setText("12/22")
        buttonPressed()
    }

}
