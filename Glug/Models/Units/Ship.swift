//
//  Ship.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Ship: CKUnit {

    weak var diver: Diver?
    
    var loaderArea: CKRect {
        let r = rect
        return CKRect(origin: r.origin, size: r.size + CKSize(0, 1))
    }
    
    override func update(time: UpdateTime) {
        super.update(time)
        
        guard let diverCenter = diver?.center else {
            return
        }
        
        center = CKPoint(diverCenter.x, center.y)
    }
    
    init(center: CKPoint) {
        super.init(sprite: CKSprite("🚤"), center: center) 
    }
}
