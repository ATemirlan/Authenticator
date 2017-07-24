//
//  AppDelegate.swift
//  LocalAuthenticator
//
//  Created by Темирлан Алпысбаев on 6/27/17.
//  Copyright © 2017 TemirlanAlpysbayev. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var timer: Float!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        if let vc = getViewController() {
            vc.stopProgressAnimation()
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let vc = getViewController() {
            vc.startProgressAnimation()
        }
    }
    
    func getViewController() -> ViewController? {
        if let rootVC = window?.rootViewController as? UINavigationController {
            if let vc = rootVC.viewControllers[0] as? ViewController {
                return vc
            }
        }
        
        return nil
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        CoreDataStack.shared.save()
    }

}

