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
import PayMayaSDK

class PaymentsViewController: UIViewController {
    
    private let viewModel = PaymentsViewModel()
    
    override func loadView() {
        view = PaymentsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let view = view as? PaymentsView else { return }
        
        let paymentInfo = viewModel.getSinglePaymentInfo()
        view.setAmount(paymentInfo.totalAmount.value, currencyCode: paymentInfo.totalAmount.currency)
        
        view.payWithPayMayaAction = { [weak self] in
            self?.createSinglePayment()
        }
        
        view.createWalletAction = { [weak self] in
            self?.createWallet()
        }
    }
    
}

private extension PaymentsViewController {
    
    func createSinglePayment() {
        let paymentInfo = viewModel.getSinglePaymentInfo()
        PayMayaSDK.singlePayment(paymentInfo, context: self) { result in
            switch result {
            case .prepared(let paymentId):
                print("### \(paymentId)")
                
            case .processed(let status):
                switch status {
                case .success(let url):
                    self.showAlert("SUCCESS: \(url)")
                case .failure(let url):
                    self.showAlert("FAILED: \(url)")
                case .cancel(let url):
                    self.showAlert("CANCELLED: \(url)")
                }
                
            case .interrupted(let paymentStatus):
                self.showAlert("INTERRUPTED: \(paymentStatus.rawValue)")
                
            case .error(let error):
                self.showAlert("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func createWallet() {
        let walletLink = viewModel.getWalletLinkInfo()
        PayMayaSDK.createWallet(walletLink, context: self) { result in
            switch result {
            case .prepared(let linkId):
                print("### \(linkId)")
                
            case .processed(let status):
                switch status {
                case .success(let url):
                    self.showAlert("Wallet created:\n \(url)")
                case .failure(let url):
                    self.showAlert("FAILED: \(url)")
                case .cancel(let url):
                    self.showAlert("CANCELLED: \(url)")
                }
                
            case .interrupted(let paymentStatus):
                self.showAlert("INTERRUPTED: \(paymentStatus.rawValue)")
                
            case .error(let error):
                self.showAlert("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    func showAlert(_ message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self.present(alert, animated: true)
        }
    }
    
}
