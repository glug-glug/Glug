//
//  Tube.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Tube: CKUnit {
    
    weak var diver: Diver?
    weak var ship: Ship?
    
    let chunk = "🔹" // 🔸🔹▫️❕
    
    var length: Int {
        get {
            return sprite.size.height
        }
        set (l) {
            if l <= 0 {
                sprite = CKSprite([])
            } else if length != l {
                sprite = CKSprite(Array(count: l, repeatedValue: chunk))
            }
        }
    }
    
    override func update(time: UpdateTime) {
        super.update(time)
        update()
    }
    
    func update() {
        guard let diver = diver, ship = ship else {
            return
        }
        position = CKPoint(ship.center.x, (ship.position + ship.sprite.size.point).y)
        length = (diver.position - ship.position - ship.sprite.size.point).y
    }
    
    init() {
        super.init(sprite: CKSprite(chunk))
    }    
}
