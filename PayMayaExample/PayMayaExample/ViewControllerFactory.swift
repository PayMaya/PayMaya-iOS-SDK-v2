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

class ViewControllerFactory {
    func makeRootViewController() -> UIViewController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [makeShopViewController(), makeSinglePaymentViewController(), makeCardPaymentViewController()]
        return tabBarController
    }
}

private extension ViewControllerFactory {
    func makeShopViewController() -> UIViewController {
        let shopViewController = ShopViewController()
        shopViewController.title = "Shop"
        return makeNavigationController(with: shopViewController)
    }
    
    func makeSinglePaymentViewController() -> UIViewController {
        let viewController = PaymentsViewController()
        viewController.title = "Payments"
        return makeNavigationController(with: viewController)
    }
    
    func makeCardPaymentViewController() -> UIViewController {
        let viewController = PayWithCardViewController()
        viewController.title = "Card"
        return makeNavigationController(with: viewController)
    }
    
    func makeNavigationController(with root: UIViewController) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: root)
        navigationController.tabBarItem.image = UIImage(named: "shop")
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
