//
//  AppActivating.swift
//  Glug
//
//  Created by piton on 29.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

protocol AppActivating: class {

    func appWillResignActive()
    func appDidBecomeActive()
    
    func startListenActivationEnevts()
    func stopListenActivationEnevts()
}

extension AppActivating {
    func startListenActivationEnevts() {
        let def = NSNotificationCenter.defaultCenter()
        def.addObserver(self, selector: "appWillResignActive", name: UIApplicationWillResignActiveNotification, object: nil)
        def.addObserver(self, selector: "appDidBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    func stopListenActivationEnevts() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}