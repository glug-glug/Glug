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
    
    weak var ship: Ship?
    weak var tube: Tube?
    
    var killed = false
    
    override var direction: Directions? {
        didSet {
            speed = direction == nil ? .Zero : baseSpeed
        }
    }

    override var position: CKPoint {
        didSet {
            checkHerb()
            
            ship?.update()
            tube?.update()
            treasure = { treasure }()
        }
    }
    
    override var removed: Bool {
        didSet {
            killed = true
        }
    }
    
    var treasure: Treasure? {
        didSet {
            treasure?.center = center
            treasure?.canOut = false
        }
    }
    
    lazy var sprites: (left: CKSprite, right: CKSprite) = {
        
        let b = CharKit.bg
        
        let left =
        "👀\n" +
        "👈"
        
        let right =
        "👀\n" +
        "👉"
        
        return (
            CKSprite(left),
            CKSprite(right)
        )
    }()
    
    func refreshSprite() {
        var s = sprites.right
        if case .Left? = self.turn.horizontal {
            s = sprites.left
        }
        sprite = s
    }
    
    init(center: CKPoint) {
        
        super.init(center: center, solid: true)

        turnChanged = { [weak self] turn in
            guard let s = self where turn == .Left || turn == .Right else {
                return
            }
            if case .Left = turn {
                s.sprite = s.sprites.left
            } else {
                s.sprite = s.sprites.right
            }
        }

        direction = .Right
        direction = nil
    }
    
    func fire() -> Bullet? {
        
        guard let dir = turn.horizontal else {
            return nil
        }
        
        let x = position.x + (dir == .Left ? 0 : sprite.size.width - 1)
        let y = position.y + 1
        let center = CKPoint(x, y)
        
        let bullet = Bullet(center: center, direction: dir)
        
        return bullet
    }
    
    func checkCollisions() {
        checkTreasure()
//        checkFish()
//        checkHerb()
    }
    
    private func checkTreasure() {
        
        if let treasure = treasure {
            if ship?.loaderArea.intersects(rect) ?? false {
                treasure.deliver()
                self.treasure = nil
            }
        } else {
            treasure = scene?[self, { $0 is Treasure }].first as? Treasure
        }
        
        treasure = { treasure }()
    }
    
    private func checkFish() {
        let fish = scene?[self, { $0 is Fish }].first
        if fish != nil {
            killed = true
        }
    }
    
    private func checkHerb() {
        if scene?[self, { $0 is Herb }].isEmpty ?? true {
            return
        }
        position += Directions.Left
    }
}
