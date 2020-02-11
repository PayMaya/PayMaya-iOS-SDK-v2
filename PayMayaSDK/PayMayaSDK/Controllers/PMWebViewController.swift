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
import WebKit

class PMWebViewController: UIViewController {
    
    var onChangedURL: ((String) -> Void)?
    var onError: ((Error) -> Void)?
    var onDismiss: (() -> Void)?

    init(title: String) {
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }
    
    override func loadView() {
        self.view = PMWebView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Log.verbose("View loaded.")
        setupNavigationItem()
        (view as? PMWebView)?.webView.navigationDelegate = self
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }
    
    func loadURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            let error = NetworkError.invalidURL(url: urlString)
            onError?(error)
            Log.error(error.localizedDescription)
            return
        }
        let request = URLRequest(url: url)
        (view as? PMWebView)?.webView.load(request)
        Log.info("Loading URL: \(url.absoluteString)")
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension PMWebViewController {
    func setupNavigationItem() {
        let closeButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissControlller))
        navigationItem.leftBarButtonItem = closeButtonItem
    }
    
    @objc func dismissControlller() {
        dismiss(animated: true) { [weak self] in
            self?.onDismiss?()
            Log.verbose("Controller dismissed by user")
        }
    }
}

extension PMWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        (view as? PMWebView)?.indicatorView.startAnimating()
        if let url = webView.url {
            onChangedURL?(url.absoluteString)
            Log.info("WKNavigationDelegate: redirecting to \(url.absoluteString)")
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        (view as? PMWebView)?.indicatorView.stopAnimating()
        Log.verbose("Web view did finish loading \(webView.url?.absoluteString ?? "")")
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        (view as? PMWebView)?.indicatorView.stopAnimating()
        onError?(error)
        Log.error("WKNavigationDelegate: error redirecting to \(webView.url?.absoluteString ?? "") : \(error.localizedDescription)")
    }
}
