//
//  Fish.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Fish: CKUnit, HitProtocol {
    
    var killed = false
    var shark = false
    
    init(sprite: CKSprite,
        position: CKPoint,
        speed: CKSpeed = .Medium,
        direction: Directions = .Left) {
            
            super.init(
                sprite: sprite,
                position: position,
                direction: direction,
                speed: speed,
                zPosition: 3,
                canOut: true
            )
    }
    
    convenience init(_ sprite: CKSprite,
        _ position: CKPoint,
        _ speed: CKSpeed,
        _ direction: Directions = .Left,
        _ shark: Bool = false) {
            
            self.init(
                sprite: sprite,
                position: position,
                speed: speed,
                direction: direction
            )
            self.shark = shark
    }
    
    func hit() {
        killed = true
        remove()
    }
}


