# PayMayaSDK
The PayMaya iOS SDK is a library that allows you to easily add credit and debit card as payment options to your mobile application.

## Compatibility
iOS 12.0 or later

## Integration

##### via CocoaPods
If you use [CocoaPods](http://cocoapods.org/), then add these lines to your podfile:
```
pod 'PayMayaSDK'
```

##### via Swift Package Manager
```
.package(url: "https://github.com/PayMaya/PayMaya-iOS-SDK.git")
```

## Initialization
1. Initialize the SDK by specifying intended environment either sandbox or production and a optional level of console logging (off by default). It is recommended to do this in your app delegate's didFinishLaunchingWithOptions: method
2. Provide your API key for a specific payment method you want to use (it can be more than one)
```
import PayMayaSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	...
    // 1
	PayMayaSDK.setup(environment: .sandbox, logLevel: .all)

    // 2
    PayMayaSDK.add(authenticationKey: "pk-Z0OSzLvIcOI2UIvDhdTGVVfRSSeiGStnceqwUE7n0Ah", for: .checkout)
    ...
}
```

## Using Checkout
1. Create a CheckoutInfo object with total amount, items, redirection urls, request reference number and optional buyer information.
```
let itemsToBuy = [
    CheckoutItem(name: "Shoes",
                 quantity: 1,
                 totalAmount: CheckoutItemAmount(value: 99)),
    CheckoutItem(name: "Pants",
                 quantity: 1,
                 totalAmount: CheckoutItemAmount(value: 79)),
]

let totalAmount = CheckoutTotalAmount(value: itemsToBuy.map { $0.totalAmount.value }.reduce(0, +), currency: "PHP")

let redirectUrl = RedirectURL(success: "https://www.merchantsite.com/success", 
                              failure: "https://www.merchantsite.com/failure", 
                              cancel: "https://www.merchantsite.com/cancel")!
                              
let checkoutInfo = CheckoutInfo(totalAmount: totalAmount, items: itemsToBuy, redirectUrl: redirectUrl, requestReferenceNumber: "1551191039")
```
2. Call PayMayaSDK.checkout method passing the CheckoutInfo object and the context where the new view controller will present itself.
```
// SomeViewController.swift
import PayMayaSDK

func buyButtonTapped() {
    PayMayaSDK.checkout(checkoutInfo, context: self) { result in
        switch result {
        
        // Called once the checkout id is created
        case .prepared(let checkoutId):
            
        // Called once the transaction is finished
        case .processed(let status):
        
            // The transaction status with your redirection url provided in the CheckoutInfo object
            switch status {
            case .success(let url):
                
            case .failure(let url):
                
            case .cancel(let url):
                
            }
            
        // Called when user dismisses the checkout controller, passes the last known status.
        case .interrupted(let status):
        
        // For error handling
        case .error(let error):
        }
    }

}
```
* (if needed) Checking status for a checkout id
```
import PayMayaSDK

func getStatus() {
    PayMayaSDK.getCheckoutStatus(id: "someCheckoutId") { result in
        switch result {
        
        // Status for that checkout id
        case .success(let status):
            
        // For error handling
        case .failure(let error):
            
        }
    }
}
```
## Using Pay with PayMaya
### Single Payment
1. Create a SinglePaymentInfo object with total amount, redirection urls and a request reference number.
```
let redirectUrl = RedirectURL(success: "https://www.merchantsite.com/success",
                              failure: "https://www.merchantsite.com/failure",
                              cancel: "https://www.merchantsite.com/cancel")!
                              
let totalAmount = SinglePaymentTotalAmount(currency: "PHP", value: 199)

let singlePaymentInfo = SinglePaymentInfo(totalAmount: totalAmount, redirectUrl: redirectUrl, requestReferenceNumber: "6319921")
```
2. Call PayMayaSDK.singlePayment method passing the SinglePaymentInfo object and the context where the new view controller will present itself.
```
// SomeViewController.swift
import PayMayaSDK

func payButtonTapped() {
    PayMayaSDK.singlePayment(singlePaymentInfo, context: self) { result in
        switch result {
        
        // Called once the payment id is created
        case .prepared(let paymentId):
            
        // Called once the transaction is finished
        case .processed(let status):
        
            // The transaction status with your redirection url provided in the SinglePaymentInfo object
            switch status {
            case .success(let url):
                
            case .failure(let url):
                
            case .cancel(let url):
                
            }
            
        // Called when user dismisses the payment controller, passes the last known status.
        case .interrupted(let status):
        
        // For error handling
        case .error(let error):
        }
    }

}
```
* (if needed) Checking status for a payment id
```
import PayMayaSDK

func getStatus() {
    PayMayaSDK.getPaymentStatus(id: "somePaymentId") { result in
        switch result {
        
        // Status for that payment id
        case .success(let status):
            
        // For error handling
        case .failure(let error):
            
        }
    }
}
```
### Creating a Wallet Link
1. Create a WalletLinkInfo object with redirection urls and a request reference number.
```
let redirectUrl = RedirectURL(success: "https://www.merchantsite.com/success",
                              failure: "https://www.merchantsite.com/failure",
                              cancel: "https://www.merchantsite.com/cancel")!
                              
let walletLinkInfo = WalletLinkInfo(redirectUrl: redirectUrl, requestReferenceNumber: "123456")
```
2. Call PayMayaSDK.createWallet method passing the WalletLinkInfo object and the context where the new view controller will present itself.
```
// SomeViewController.swift
import PayMayaSDK

func createWalletButtonTapped() {
    PayMayaSDK.createWallet(walletLinkInfo, context: self) { result in
        switch result {
        
        // Called once the wallet link id is created
        case .prepared(let walletId):
            
        // Called once the wallet link is created
        case .processed(let status):
        
            // The transaction status with your redirection url provided in the WalletLinkInfo object
            switch status {
            case .success(let url):
                
            case .failure(let url):
                
            case .cancel(let url):
                
            }
            
        // Called when user dismisses the payment controller, passes the last known status.
        case .interrupted(let status):
        
        // For error handling
        case .error(let error):
        }
    }

}
```
* (if needed) Checking status for a wallet link id - see **Checking status for a payment id**
## Using Payment Vault
Payment Vault provides merchants the ability to store their customer's card details and charge for payments on-demand

### Create Payment Token
Call PayMayaSDK.cardPayment method passing context where the new view controller will present itself.
```
PayMayaSDK.cardPayment(self) { result in

    switch result {
    
    // Called once the payment token is created
    case .success(let token):
        
    // For error handling
    case .error(let error):
    
    }
}
```
### Optional styling
Call the method and choose between .dark / .light with your custom font, logo and tint color that will be used across the screen. All parameters are optional, so you can change only the ones you want.
```
let tintColor = UIColor.green
let font = UIFont.systemFont(ofSize: 18)
let logo = UIImage(named: "myLogo")

PayMayaSDK.cardPayment(self, styling: .dark(tintColor: tintColor, font: font, logo: logo) { result in
    ...
}
```
