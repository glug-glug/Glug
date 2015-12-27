//
//  NibView.swift
//  Glug
//
//  Created by piton on 27.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

class NibView: UIView {
    
    var nibName: String {
        fatalError("Must be overriden")
    }
    
    convenience init() {
        self.init(frame: .zero)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNib()
    }
    
    func loadNib() {
        let nib = UINib(nibName: nibName, bundle: NSBundle(forClass: self.dynamicType))
        let view = nib.instantiateWithOwner(self, options: nil).first as! UIView
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        addSubview(view);
    }
}
