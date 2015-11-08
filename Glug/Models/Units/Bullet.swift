//
//  Bullet.swift
//  Glug
//
//  Created by piton on 07.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Bullet: CKUnit {
    
    typealias ExplodedTime = Int
    
    let explodedTimeToLive = 1
    
    enum Kinds {
        case Simple
        
        var sprite: CKSprite {
            switch self {
            case Simple:
                return CKSprite("🔸")
            }
        }
        
        var explodedSprite: CKSprite {
            switch self {
            case Simple:
                return CKSprite("💥")
            }
        }
    }
    
    let kind: Kinds

    private var exploded = false {
        didSet {
            if !exploded {
               return
            }
            speed = .Zero
            sprite = kind.explodedSprite
        }
    }
    
    private var explodedTime: ExplodedTime = 0 {
        didSet {
            if explodedTime > explodedTimeToLive {
                remove()
            }
        }
    }
    
    override func update(time: UpdateTime) {
        super.update(time)
        
        if exploded {
            explodedTime++
        }
    }
    
    init(center: CKPoint, direction: Directions, kind: Kinds = .Simple) {
        self.kind = kind
        super.init(sprite: kind.sprite, center: center, speed: .Max, direction: direction, canOut: true, zPosition: 10)
    }

    func explode() {
        exploded = true
    }
    
    func hits() {
        
        if exploded {
            return
        }
        
        let hits = scene?[self, { $0 is HitProtocol }] ?? []
        
        if !hits.isEmpty {
            explode()
        }
        
        hits.forEach {
            ($0 as? HitProtocol)?.hit()
        }
    }
}