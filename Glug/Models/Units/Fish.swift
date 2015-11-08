//
//  Fish.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Fish: CKUnit, HitProtocol {
    
    override func update(time: UpdateTime) {
        super.update(time)
        
        // TODO: tmp test
//        if next == nil {
//            direction?.invert()
//            remove()
//        }
    }
    
    init(center: CKPoint, direction: Directions, speed: CKSpeed = .Medium, sprite: CKSprite, solid: Bool = false) {
        super.init(sprite: sprite, center: center, direction: direction, speed: speed, solid: solid, canOut: true)
    }
    
    // TODO:
    init(position: CKPoint, direction: Directions, speed: CKSpeed = .Medium, sprite: CKSprite, canOut: Bool = false, solid: Bool = false) {
        super.init(sprite: sprite, position: position, direction: direction, speed: speed, solid: solid, canOut: canOut)
    }    
}


