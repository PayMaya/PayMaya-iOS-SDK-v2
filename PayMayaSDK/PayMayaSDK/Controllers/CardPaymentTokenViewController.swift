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

class CardPaymentTokenViewController: UIViewController {
    
    private let initialData: CardPaymentTokenInitialData
    
    init(with data: CardPaymentTokenInitialData) {
        self.initialData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = CardPaymentTokenView(with: CardPaymentTokenViewModel(data: initialData,
                                                                         onHintTapped: { [weak self] in self?.showHint(from: $0) }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
        }
    }
    
    func hideActivityIndicator() {
        (view as? CardPaymentTokenView)?.hideActivityIndicator()
    }
}

private extension CardPaymentTokenViewController {

    func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))
        navigationController?.navigationBar.barTintColor = initialData.styling.navbarColor
    }
    
    @objc func cancel() {
        dismiss(animated: true)
    }
    
    func showHint(from view: UIView) {
        let hintViewController = HintViewController(sourceView: view)
        hintViewController.popoverPresentationController?.delegate = self
        present(hintViewController, animated: true)
    }
}

extension CardPaymentTokenViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}
