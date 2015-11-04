//
//  Diver.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Diver: CKTurnedUnit {
    
    let baseSpeed = CKSpeed.High
    
    override var direction: Directions? {
        didSet {
            if direction == nil {
                speed = .Zero
            } else {
                speed = baseSpeed
            }
        }
    }
    
    lazy var sprites: (left: CKSprite, right: CKSprite) = {
        
        let b = CharKit.bg
        
        let left =
        "◻️👀◻️\n" +
        "👈⚪️◻️"
        
        let right =
        "◻️👀◻️\n" +
        "◻️⚪️👉"
        
        return (
            CKSprite(left),
            CKSprite(right)
        )
    }()
    
    override func update(time: UpdateTime) {
        super.update(time)
    }

    init(center: CKPoint) {
        
        super.init(center: center)

        turnChanged = { [weak self] turn in
            guard let s = self else {
                return
            }
            if case .Left = turn {
                s.sprite = s.sprites.left
            } else if case .Right = turn {
                s.sprite = s.sprites.right
            }
        }

        direction = .Right
        direction = nil
        solid = true
    }
}

//        if let d = dir(hero.lastDirection.horizontal) {
//
//            let x = d == .Left ? hero.position.x : hero.position.x + 2
//
//            let pos = CKPoint(x, hero.position.y + 1)
//            let unit = CKUnit(sprite: CKSprite(character: "🔹"), position: pos, speed: 1, direction: d)
//            rockets.insert(unit, atIndex: 0)
//            scene.addUnit(unit)
//
//            while rockets.count > 30 {
//                let unit = rockets.last!
//                scene.removeUnit(unit)
//                rockets.removeLast()
//            }
//        }