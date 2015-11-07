//
//  Constraint.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

typealias Constraint = NSLayoutConstraint

extension NSLayoutConstraint {
    static func add(view: UIView, _ format: String, _ views: [String : AnyObject]) {
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: views))
    }
}


