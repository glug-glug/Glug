//
//  Fish.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Fish: CKUnit {
    
    override func update(time: UpdateTime) {
        super.update(time)
        
        // TODO: tmp test
        if nexOutOfScene && !canOut {
            direction?.invert()
        }
    }
    
    init(center: CKPoint, direction: Directions, speed: Int = 1, sprite: CKSprite) {
        super.init(sprite: sprite, center: center, direction: direction, speed: speed)
    }
    // TODO:
    init(position: CKPoint, direction: Directions, speed: Int = 1, sprite: CKSprite, canOut: Bool = false) {
        super.init(sprite: sprite, position: position, direction: direction, speed: speed)
        self.canOut = canOut
    }
}
