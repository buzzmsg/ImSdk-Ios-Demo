//
//  AppDelegate.swift
//  IMSdk-Ios-demo
//
//  Created by oceanMAC on 2022/10/10.
//

import UIKit
import CoreData
import IMSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    public var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white
        
        if TMUserUtil.shared.isLogged {
            TMUserUtil.shared.initIMSdk()
            self.window?.rootViewController = TMTabbarController()
        } else {
            self.window?.rootViewController = TMLoginController()
        }
        self.window?.makeKeyAndVisible()
        
        return true
    }
}

extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {

    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {


    }
}
