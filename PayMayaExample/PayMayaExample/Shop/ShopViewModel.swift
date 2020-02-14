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

class ShopViewModel: NSObject {
    
    private let items: [CheckoutItem] = [
        CheckoutItem(name: "Shoes",
                     quantity: 1,
                     code: "1",
                     description: "Nice shoes",
                     amount: .init(value: 99,
                                   details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 99)),
                     totalAmount: .init(value: 99,
                                        details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 99))),
        CheckoutItem(name: "Shirt",
                     quantity: 1,
                     code: "2",
                     description: "Nice shirt",
                     amount: .init(value: 39,
                                   details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 39)),
                     totalAmount: .init(value: 39,
                                        details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 39))),
        CheckoutItem(name: "Pants",
                     quantity: 1,
                     code: "3",
                     description: "Nice pants",
                     amount: .init(value: 79,
                                   details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 79)),
                     totalAmount: .init(value: 79,
                                        details: .init(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: 79)))
    ]
    
    var cart: [CheckoutItem] = []
    
    var onCartChange: (([CheckoutItem]) -> Void)?
    
    func cleanCart() {
        cart = []
        onCartChange?(cart)
    }
    
    func getCheckoutInfo() -> CheckoutInfo {
        let contact = Contact(phone: "+639181008888", email: "merchant@merchantsite.com")
        let shippingAddress = ShippingAddress(firstName: "John", middleName: "Paul", lastName: "Doe", phone: "+639181008888", email: "merchant@merchantsite.com", line1: "6F Launchpad", line2: "Reliance Street", city: "Mandaluyong City", state: "Metro Manila", zipCode: "1552", countryCode: "PH", shippingType: "ST")
        let billingAddress = BillingAddress(line1: "6F Launchpad", line2: "Reliance Street", city: "Mandaluyong City", state: "Metro Manila", zipCode: "1552", countryCode: "PH")
        let buyer = CheckoutBuyer(firstName: "John", middleName: "Paul", lastName: "Doe", birthday: "1995-10-24", customerSince: "1995-10-24", sex: "M", contact: contact, shippingAddress: shippingAddress, billingAddress: billingAddress)
        let totalValue = cart.map { $0.totalAmount.value }.reduce(0, +)
        let amountDetails = AmountDetails(discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: totalValue)
        let totalAmount = CheckoutTotalAmount(value: totalValue, currency: "PHP", details: amountDetails)
        let redirectUrl = RedirectURL(success: "https://www.merchantsite.com/success", failure: "https://www.merchantsite.com/failure", cancel: "https://www.merchantsite.com/cancel")!
        return CheckoutInfo(totalAmount: totalAmount, buyer: buyer, items: cart, redirectUrl: redirectUrl, requestReferenceNumber: "1551191039")
    }
}

extension ShopViewModel: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(ShopItemCell.self, for: indexPath)!
        let item = items[indexPath.row]
        cell.setup(title: item.name, price: item.totalAmount.value, backgroundColors: gradients[indexPath.row])
        cell.buttonAction = { [weak self] btn in
            btn.isEnabled = false
            self?.updateCart(with: item)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

private extension ShopViewModel {
    func updateCart(with item: CheckoutItem) {
        cart.append(item)
        onCartChange?(cart)
    }
}
