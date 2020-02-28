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

/// Payment result type.
public enum PaymentResult {
    
    /// Called when the id is created.
    case prepared(id: String)
    
    /// Called when the transaction is finished with the proper status.
    case processed(status: RedirectStatus)
    
    /// Called when the process was interrupted by the user.
    case interrupted(paymentStatus: PaymentStatus?)
    
    /// Called when got an error.
    case error(Error)
}

/// Payment result callback.
/// It can be called multiple times during payment process with different values.
public typealias PaymentCallback = (PaymentResult) -> Void

class WebViewPaymentUseCase<NetworkRequest: Request> {
    private let session: Networking
    private let authenticationKey: String
    private let request: NetworkRequest
    private let redirectURL: RedirectURL
    private let navigationTitle: String
    private let callback: PaymentCallback
    private let withStatusCheck: Bool

    private var id: String?
    private var dismissAction: (() -> Void)?

    init(session: Networking,
         authenticationKey: String,
         request: NetworkRequest,
         redirectURL: RedirectURL,
         navigationTitle: String,
         withStatusCheck: Bool = true,
         callback: @escaping PaymentCallback) {
        self.session = session
        self.authenticationKey = authenticationKey
        self.request = request
        self.redirectURL = redirectURL
        self.navigationTitle = navigationTitle
        self.withStatusCheck = withStatusCheck
        self.callback = callback
    }
}

extension WebViewPaymentUseCase where NetworkRequest.Response: RedirectResponse {
    func showWebView(context: UIViewController) {
        Log.info("Starting WebViewPaymentUseCase process")
        let webViewController = makeWebViewController()
        let navVC = UINavigationController(rootViewController: webViewController)
        
        DispatchQueue.main.async {
            context.present(navVC, animated: true)
        }

        dismissAction = { [weak webViewController] in
            webViewController?.dismiss(animated: true)
        }

        makeRequest(andLoad: webViewController)
    }

}

private extension WebViewPaymentUseCase where NetworkRequest.Response: RedirectResponse {
    func makeWebViewController() -> PMWebViewController {
        let webViewController = PMWebViewController(title: navigationTitle)
        webViewController.onChangedURL = onChangedUrl
        webViewController.onError = onError
        webViewController.onDismiss = getStatus
        return webViewController
    }

    func makeRequest(andLoad webViewController: PMWebViewController) {
        session.make(request) { result in
            switch result {
            case .success(let response):
                self.id = response.id
                self.callback(.prepared(id: response.id))
                Log.info("Got response with id \(response.id)")
                DispatchQueue.main.async {
                    webViewController.loadURL(response.redirectUrl)
                }
                
            case .failure(let data):
                DispatchQueue.main.async {
                    self.dismissAction?()
                }
                let error = data.parseError()
                self.callback(.error(error))
                Log.error(error.localizedDescription)

            case .error(let error):
                DispatchQueue.main.async {
                    self.dismissAction?()
                }
                self.callback(.error(error))
                Log.error(error.localizedDescription)
            }
        }
    }

    func getStatus() {
        guard withStatusCheck, let id = self.id else {
            self.callback(.interrupted(paymentStatus: nil))
            return
        }
        let redirectURL = self.redirectURL

        GetStatusUseCase(session: session).getStatus(for: id, authenticationKey: authenticationKey) { result in
            switch result {
            case .success(let status):
                switch status {
                case .paymentSuccess:
                    self.callback(.processed(status: .success(redirectURL.success)))
                case .authFailed, .paymentFailed:
                    self.callback(.processed(status: .failure(redirectURL.failure)))
                default:
                    self.callback(.interrupted(paymentStatus: status))
                }
            case .failure(let error):
                self.callback(.error(error))
            }
        }
    }

    func onChangedUrl(_ url: String) {
        if let status = redirectURL.status(for: url) {
            dismissAction?()
            callback(.processed(status: status))
            Log.info("Finished process: redirecting to \(url) with \(status)")
        }
    }

    func onError(_ error: Error) {
        dismissAction?()
        callback(.error(error))
        Log.error(error.localizedDescription)
    }
}
