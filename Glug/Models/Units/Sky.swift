//
//  Sky.swift
//  Glug
//
//  Created by piton on 01.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Sky: CKUnit {
    
    override func update(time: UpdateTime) {
        super.update(time)
    }
    
    init(rect: CKRect) {
        
        let ch = "😑"//CharKit.bg //"" // ⬜️
        
        let s = rect.size
        let data = Array(count: s.height, repeatedValue: ch * s.width)

        super.init(sprite: CKSprite(data), position: rect.origin)
        
        solid = true
    }
}
