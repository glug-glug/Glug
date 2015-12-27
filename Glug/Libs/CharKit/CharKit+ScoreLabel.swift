//
//  CharKit+ScoreLabel.swift
//  Glug
//
//  Created by piton on 21.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

extension CharKit {
    
    class ScoreLabel: UILabel {

        var score: Score {
            get {
                return Score(text ?? "") ?? 0
            }
            set {
                text = newValue > 0 ? "\(newValue)" : ""
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            initialize()
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            initialize()
        }
        
        convenience init() {
            self.init(frame: .zero)
        }
        
        convenience init(view: UIView) {
            self.init()
            
            translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(self)
            self.bringSubviewToFront(view)
            
            let views = ["l": self]
            
            Constraint.add(view, "H:[l]-10-|", views)
            Constraint.add(view, "V:|-0-[l]", views)
        }
        
        func initialize() {
            textAlignment = .Right
            numberOfLines = 0
            let size: CGFloat = 16
            font = UIFont(name: "Minecraft", size: size) ?? UIFont.systemFontOfSize(size)
            textColor = UIColor(hex: 0xff_ff_ff, alpha: 0.8)
        }
    }
}