//
//  AppDelegate.swift
//  PaymayaExample
//
//  Created by Maciej Górecki on 21/01/2020.
//  Copyright © 2020 Maciej Górecki. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
      window = UIWindow(frame: UIScreen.main.bounds)
      window?.makeKeyAndVisible()
      window?.rootViewController = ViewController()
      
      return true
    }


}

