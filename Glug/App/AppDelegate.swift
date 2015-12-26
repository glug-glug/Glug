//
//  AppDelegate.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        sleep(5)
        
        cusomizeAppearance()
        return true
    }
}

extension AppDelegate {

    func cusomizeAppearance() {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
}


