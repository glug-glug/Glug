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
    
    init(sprite: CKSprite,
        center: CKPoint,
        speed: CKSpeed = .Medium,
        direction: Directions = .Left) {
            
        super.init(
            sprite: sprite,
            center: center,
            direction: direction,
            speed: speed,
            zPosition: 3,
            canOut: true
            )
    }
    
    convenience init(sprite: CKSprite, _ center: CKPoint, _ speed: CKSpeed, shark: Bool = false) {
        self.init(
            sprite: sprite,
            center: center,
            speed: speed
        )
    }
    
    func hit() {
        killed = true
        remove()
    }
}


