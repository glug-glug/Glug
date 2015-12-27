//
//  Backing.swift
//  Glug
//
//  Created by piton on 26.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

protocol Backing {
    func back()
}

extension Backing where Self: UIViewController {
    
    func back() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}