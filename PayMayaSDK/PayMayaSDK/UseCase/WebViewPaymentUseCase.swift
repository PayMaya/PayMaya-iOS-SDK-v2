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

public enum PaymentResult {
    case prepared(id: String)
    case processed(status: RedirectStatus)
    case error(Error)
}

public typealias PaymentCallback = (PaymentResult) -> Void

class WebViewPaymentUseCase<NetworkRequest: Request> {
    private let session: Networking
    private let request: NetworkRequest
    private let redirectURL: RedirectURL
    private let navigationTitle: String

    init(session: Networking, request: NetworkRequest, redirectURL: RedirectURL, navigationTitle: String) {
        self.session = session
        self.request = request
        self.redirectURL = redirectURL
        self.navigationTitle = navigationTitle
    }
}

extension WebViewPaymentUseCase where NetworkRequest.Response: RedirectResponse {
    func showWebView(context: UIViewController, callback: @escaping PaymentCallback) {
        
        let webViewController = PMWebViewController(title: navigationTitle)
        let navVC = UINavigationController(rootViewController: webViewController)
        
        DispatchQueue.main.async {
            context.present(navVC, animated: true)
        }

        let redirectURL = self.redirectURL
        
        webViewController.onChangedURL = { [weak webViewController] url in
            if let status = redirectURL.status(for: url) {
                webViewController?.dismiss(animated: true)
                callback(.processed(status: status))
            }
        }
        
        webViewController.onError = { [weak webViewController] error in
            webViewController?.dismiss(animated: true)
            callback(.error(error))
        }
        
        session.make(request) { result in
            switch result {
            case .success(let response):
                callback(.prepared(id: response.id))
                DispatchQueue.main.async {
                    webViewController.loadURL(response.redirectUrl)
                }
                
            case .failure(let data):
                DispatchQueue.main.async {
                    webViewController.dismiss(animated: true)
                }
                guard let error: PayMayaError = data.parseJSON() else {
                    callback(.error(NetworkError.incorrectData))
                    return
                }
                callback(.error(error))
            case .error(let error):
                DispatchQueue.main.async {
                    webViewController.dismiss(animated: true)
                }
                callback(.error(error))
            }
        }
    }

}
