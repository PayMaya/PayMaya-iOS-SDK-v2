////
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

/// Card creation result type.
public enum CreateCardResult {
    
    /// Called when process finished.
    case success(CardPaymentTokenResponse)
    
    /// Called when got an error.
    case error(Error)
}

class CardPaymentTokenUseCase {
    private let authenticationKey: String
    private let session: Networking
    
    private var callback: ((CreateCardResult) -> Void)?
    private weak var executionContext: CardPaymentTokenViewController?
    
    init(session: Networking, authenticationKey: String) {
        self.authenticationKey = authenticationKey
        self.session = session
    }
    
    func start(context: UIViewController,
               styling: CardPaymentTokenViewStyle,
               callback: @escaping (CreateCardResult) -> Void) {
        Log.info("Starting CardPaymentTokenUseCase process")
        let initData = CardPaymentTokenInitialData(action: cardDataReceived, styling: styling)
        let addCardVC = CardPaymentTokenViewController(with: initData)
        let navVC = UINavigationController(rootViewController: addCardVC)
        
        self.callback = callback
        self.executionContext = addCardVC
            
        DispatchQueue.main.async {
            context.present(navVC, animated: true)
        }
    }
}

private extension CardPaymentTokenUseCase {
    func cardDataReceived(_ data: CardDetailsInfo) {
        let request = CardPaymentTokenRequest(cardDetails: data, authenticationKey: authenticationKey)
        Log.info("Collected data from credit card form; Getting payment token...")
        session.make(request) { [weak self] result in
            switch result {
            case .success(let response):
                Log.info("Payment token received: \(response.paymentTokenId)")
                self?.dismiss(with: .success(response))
            case .failure(let data):
                Log.error("Failed to get payment token: \(data.parseError().localizedDescription)")
                self?.alert(with: .error(data.parseError()))
            case .error(let error):
                Log.error("Error getting payment token: \(error.localizedDescription)")
                self?.alert(with: .error(error))
            }
        }
    }
    
    func dismiss(with result: CreateCardResult) {
        DispatchQueue.main.async { [weak self] in
            Log.info("Dismissing VC with result: \(result)")
            self?.executionContext?.dismiss(animated: true) {
                self?.callback?(result)
            }
        }
    }
    
    func alert(with result: CreateCardResult) {
        guard case let CreateCardResult.error(error) = result else {return}
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: nil, message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.executionContext?.hideActivityIndicator()
            self?.executionContext?.present(alert, animated: true) {
                self?.callback?(result)
            }
        }
    }
}
