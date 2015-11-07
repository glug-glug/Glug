//
//  CharKit+Unit.swift
//  Glug
//
//  Created by piton on 27.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

extension CharKit {
    
    class Unit: Updateble {
        
        typealias Chunk = Character
        
        weak var scene: Scene!
        
        var position: Point
        var zPosition: Int
        var sprite: Sprite
        var direction: Directions?
        var speed: Speed
        var canOut: Bool
        var solid: Bool
        
        var center: Point {
            get {
                return position + sprite.size.point / 2
            }
            set (p) {
                position = p - (sprite.size / 2).point
            }
        }
        
        var rect: Rect {
            return Rect(origin: position, size: sprite.size)
        }
        
        // TODO: check all sprite
//        var outOfScene: Bool {
//            return !position.inRect(scene.rect)
//        }
        
        init(sprite: Sprite? = nil,
            position: Point? = nil,
            center: Point? = nil,
            speed: Speed = .Zero,
            direction: Directions? = nil,
            zPosition: Int = 0,
            canOut: Bool = false,
            solid: Bool = false) {
                
                self.sprite = sprite ?? Sprite.emptySprite
                self.position = position ?? Point.zeroPoint
                self.zPosition = zPosition
                self.speed = speed
                self.canOut = canOut
                self.solid = solid
                self.direction = direction
                
                if let center = center {
                    self.center = center
                }
        }
        
        subscript(point: Point) -> Character? {
            return sprite[point - position]
        }
        
        func remove() {
            scene.removeUnit(self)
        }
        
        func update(time: UpdateTime) {
            if !speed.check(time) {
                return
            }
            position = next ?? position
        }
    }
}

extension CKUnit {
    
    func intersects(position: CKPoint, sprite: CKSprite) -> Bool {
        let r = CKRect(origin: position, size: sprite.size)
        for p in rect.intersect(r).points {
            if self[p] != nil && sprite[p - position] != nil {
                return true
            }
        }
        return false
    }

    func intersects(unit: CKUnit) -> Bool {
        return intersects(unit.position, sprite: unit.sprite)
    }
    
    var next: CKPoint? {
        
        guard let dir = direction else {
            return nil
        }
        
        let pos = position + dir
        
        if canOut && !solid {
            return pos
        }
        
        let points = [pos, CKPoint(position.x, pos.y), CKPoint(pos.x, position.y)]
        
        for p in points where p != position {
            
            if !(canOut || CKRect(origin: p, size: sprite.size).inRect(scene.rect)) {
                continue
            }
            if !solid {
                return p
            }            
            if scene[p, sprite, { $0.solid && $0 !== self }].isEmpty {
                return p
            }
        }
        
        return nil
    }
}


