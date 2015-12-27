//
//  CreditView.swift
//  Glug
//
//  Created by piton on 27.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

class CreditView: NibView {
    
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var imageView: UIImageView!
    
    override var nibName: String {
        return "CreditView"
    }
    
    convenience init(_ credit: Credit) {
        self.init()
        nameLabel?.text = credit.name
        if let img = credit.image {
            imageView.image = UIImage(named: img)
        }
//        imageView.image = UIImage(named: "credit-ios-dev-course")
    }
}

class CreditGroupView: CreditView {
    
    override var nibName: String {
        return "CreditGroupView"
    }

}

extension CreditView {
    
    static func create(parent: UIView, credit: Credit) -> CreditView {
        
        let gr = credit.group ?? false
        
        let v: CreditView = gr ? CreditGroupView(credit) : CreditView(credit)
        
        let y: CGFloat = gr ? 30 : 100
        let (w, h): (CGFloat, CGFloat) = gr ? (100, 100) : (250, 40)
        v.frame = CGRectMake(parent.bounds.midX - w / 2, y, w, h)
        
        parent.addSubview(v)

        return v
    }
}

