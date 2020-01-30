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

class ViewController: UIViewController {
    
    private let buyButton = UIButton(type: .system)
    
    private var checkoutInfo: CheckoutInfo {
        let amountDetails = AmountDetails(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 100)
        let totalAmount = CheckoutTotalAmount(value: 100, currency: "PHP", details: amountDetails)
        let contact = Contact(phone: "+639181008888", email: "merchant@merchantsite.com")
        let shippingAddress = ShippingAddress(firstName: "John", middleName: "Paul", lastName: "Doe", phone: "+639181008888", email: "merchant@merchantsite.com", line1: "6F Launchpad", line2: "Reliance Street", city: "Mandaluyong City", state: "Metro Manila", zipCode: "1552", countryCode: "PH", shippingType: "ST")
        let billingAddress = BillingAddress(line1: "6F Launchpad", line2: "Reliance Street", city: "Mandaluyong City", state: "Metro Manila", zipCode: "1552", countryCode: "PH")
        let buyer = CheckoutBuyer(firstName: "John", middleName: "Paul", lastName: "Doe", birthday: "1995-10-24", customerSince: "1995-10-24", sex: "M", contact: contact, shippingAddress: shippingAddress, billingAddress: billingAddress)
        let checkoutItem = CheckoutItem(name: "Canvas Slip Ons", quantity: 1, code: "CVG-096732", description: "Shoes", amount: .init(value: 100, details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 100)), totalAmount: .init(value: 100, details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 100)))
        return CheckoutInfo(totalAmount: totalAmount, buyer: buyer, items: [checkoutItem], redirectUrl: RedirectURL(success: "https://www.merchantsite.com/success", failure: "https://www.merchantsite.com/failure", cancel: "https://www.merchantsite.com/cancel"), requestReferenceNumber: "1551191039")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        setupButton()
    }
    
    @objc private func buyButtonTapped() {
        PayMayaSDK.checkout(checkoutInfo, context: self) { [weak self] result in
            switch result {
            case .prepared(let checkoutId):
                print("### \(checkoutId)")
                
            case .success(let status):
                switch status {
                case .success(let url):
                    self?.showAlert("SUCCESS: \(url)")
                case .failure(let url):
                    self?.showAlert("FAILED: \(url)")
                case .cancel(let url):
                    self?.showAlert("CANCELLED: \(url)")
                }
                
            case .error(let error):
                self?.showAlert("ERROR: \(error.localizedDescription)")
            }
        }
    }
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func setupButton() {
        buyButton.setTitle("BUY", for: .normal)
        buyButton.backgroundColor = .white
        buyButton.layer.cornerRadius = 5
        buyButton.addTarget(self, action: #selector(buyButtonTapped), for: .touchUpInside)
        view.addSubview(buyButton)
        buyButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buyButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            buyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buyButton.widthAnchor.constraint(equalToConstant: 200),
            buyButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
