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
        
        // TODO: create new unit
        
//        if time % 10 != 0 {
//            return
//        }
//        
//        let cloud: Character = "☁️"  //🌤☀️"
//        
//        let cnt = sprite.data.count
//        let bg = Character(CharKit.bg)
//        
//        let i = (sprite.data.indexOf( { $0 == cloud } ) ?? -1) + 1
//        
//        var d: [Character?] = Array(count: cnt, repeatedValue: bg)
//        if i < d.count {
//            d[i] = cloud
//        }
//        sprite.data = d
    }
    
    init(rect: CKRect) {
        
        let ch = CharKit.bg
        let s = rect.size
        let data = Array(count: s.height, repeatedValue: ch * s.width)
        
        super.init(sprite: CKSprite(data), position: rect.origin)
        
        solid = true
    }
}
