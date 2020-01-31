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

import UIKit
import PayMayaSDK

class ShopViewController: UIViewController {
    
    private let viewModel = ShopViewModel()
    
    override func loadView() {
        view = ShopView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Shop"
        
        setupNavigationBar()
        setupViewModel()
    }
    
}

// MARK: - Checkout

private extension ShopViewController {
    func checkout() {
        let checkoutInfo = viewModel.getCheckoutInfo()
        
        PayMayaSDK.checkout(checkoutInfo, context: self) { result in
            switch result {
            case .prepared(let checkoutId):
                print("### \(checkoutId)")
                
            case .success(let status):
                switch status {
                case .success(let url):
                    self.showAlert("SUCCESS: \(url)")
                case .failure(let url):
                    self.showAlert("FAILED: \(url)")
                case .cancel(let url):
                    self.showAlert("CANCELLED: \(url)")
                }
                
            case .error(let error):
                self.showAlert("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    @objc func cleanCart() {
        viewModel.cleanCart()
        (view as? ShopView)?.tableView.reloadData()
    }
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - Setup

private extension ShopViewController {
    func setupViewModel() {
        guard let view = view as? ShopView else { return }
        view.tableView.delegate = viewModel
        view.tableView.dataSource = viewModel
        
        view.checkoutAction = { [weak self] in
            self?.checkout()
        }
        
        viewModel.onCartChange = { [weak self] cart in
            let totalAmount = cart.map { $0.totalAmount.value }.reduce(0, +)
            self?.navigationItem.title = totalAmount > 0 ? "Total: \(totalAmount)" : "Shop"
        }
    }
    
    func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(cleanCart))
    }
}
