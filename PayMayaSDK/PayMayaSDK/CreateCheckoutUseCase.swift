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
import Networking
import UIKit

public enum CheckoutResult {
    case prepared(checkoutId: String)
    case success(status: RedirectStatus)
    case error(Error)
}

public typealias CreateCheckoutCallback = (CheckoutResult) -> Void

class CreateCheckoutUseCase {
    
    private let authenticationKey: String
    private let session: Networking
    
    init(authenticationKey: String, session: Networking) {
        self.authenticationKey = authenticationKey
        self.session = session
    }
    
    func create(_ checkoutInfo: CheckoutInfo, context: UIViewController, callback: @escaping CreateCheckoutCallback) {
        
        let webViewController = PMWebViewController(title: "PayMaya Checkout")
        let navVC = UINavigationController(rootViewController: webViewController)
        
        DispatchQueue.main.async {
            context.present(navVC, animated: true)
        }
        
        let request = CheckoutRequest(checkoutInfo: checkoutInfo, authenticationKey: authenticationKey)
        
        webViewController.onChangedURL = { [weak webViewController] url in
            if let status = checkoutInfo.redirectUrl.status(for: url) {
                webViewController?.dismiss(animated: true)
                callback(.success(status: status))
            }
        }
        
        webViewController.onError = { [weak webViewController] error in
            webViewController?.dismiss(animated: true)
            callback(.error(error))
        }
        
        session.make(request) { result in
            switch result {
            case .success(let response):
                callback(.prepared(checkoutId: response.checkoutId))
                DispatchQueue.main.async {
                    webViewController.loadURL(response.redirectUrl)
                }
                
            case .failure(let data):
                DispatchQueue.main.async {
                    webViewController.dismiss(animated: true)
                }
                if let error: PayMayaError = data.parseJSON() {
                    callback(.error(error))
                } else {
                    callback(.error(NetworkError.unknown))
                }
                
            case .error(let error):
                DispatchQueue.main.async {
                    webViewController.dismiss(animated: true)
                }
                callback(.error(error))
            }
        }
    }
}
