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
    static func add(view: UIView, _ format: String, _ views: [String : AnyObject], _ options: NSLayoutFormatOptions = []) {
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: options, metrics: nil, views: views))
    }
    
    static func center(view: UIView, size: CGSize) {
        guard let s = view.superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        let views = ["v": view, "s": s]
        add(s, "V:[s]-(<=1)-[v(\(size.width))]", views, [.AlignAllCenterX])
        add(s, "H:[s]-(<=1)-[v(\(size.height))]", views, [.AlignAllCenterY])
    }
    
    static func center(view: UIView, _ width: Int, _ height: Int) {
        center(view, size: CGSizeMake(CGFloat(width), CGFloat(height)))
    }
    
    static func fill(view: UIView) {
        guard let s = view.superview else {
            return
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        let views = ["v": view]
        add(s, "V:|-0-[v]-0-|", views)
        add(s, "H:|-0-[v]-0-|", views)
    }

    static func reset(view: UIView) {
        view.removeConstraints(view.constraints)
    }
}


