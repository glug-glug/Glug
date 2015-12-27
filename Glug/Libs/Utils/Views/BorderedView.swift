//
//  BorderedView.swift
//  Glug
//
//  Created by piton on 27.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

class BorderedView: UIView {
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(CGColor: color)
            } else {
                return nil
            }
        }
        set {
            layer.borderColor = newValue?.CGColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            if newValue > 0 {
                clipsToBounds = true
            }
        }
    }
}
