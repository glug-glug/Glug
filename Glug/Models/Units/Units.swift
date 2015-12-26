//
//  Units.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Units {

    var level: Level
    
    var diver: Diver
    var ship: Ship
    var tube: Tube
    var sky: Sky
    var herbs: [Herb]
    var fishes: [Fish]
    var treasures: [Treasure]
    var bullets: [Bullet]
    
    var all: [CKUnit] {
        var all: [CKUnit] = [diver, ship, tube, sky] + fishes
        all += treasures as [CKUnit]
        all += herbs as [CKUnit]
        all += bullets as [CKUnit]
        return all
    }
    
    var missionComplete: Bool {
        return !level.isRun && treasures.isEmpty
    }

    var missionFailed: Bool {
        return diver.killed
    }
    
    var onScore: ((Score) -> ())?
    
    var score: Score = 0 {
        didSet {
            if score > oldValue {
                onScore?(score)   
            }
        }
    }
    
    init(level: Level,
        diver: Diver,
        ship: Ship,
        tube: Tube,
        sky: Sky,
        herbs: [Herb]? = nil,
        fishes: [Fish] = [],
        treasures: [Treasure]? = nil,
        bullets: [Bullet] = []) {

            self.level = level
            
            self.diver = diver
            self.ship = ship
            self.tube = tube
            self.sky = sky
            self.herbs = herbs ?? []
            self.fishes = fishes
            self.treasures = treasures ?? []
            self.bullets = bullets
            
            ship.diver = diver
            diver.ship = ship
            diver.tube = tube
            tube.ship = ship
            tube.diver = diver
    }

    func clean() {
        var arr: [CKUnit] = fishes
        arr += bullets as [CKUnit]
        arr += herbs as [CKUnit]

        arr.filter { $0.removed }.forEach {
            remove($0)
        }        
        treasures.filter { $0.removed }.forEach {
            remove($0)
        }
    }
}

extension Units: Updateble {

    func update(time: UpdateTime) {
        
        bullets.forEach {
            $0.hits()
        }
        
        diver.checkCollisions()
        
        func score() -> Score {
            return treasures.filter( { $0.delivered } ).count + fishes.filter( { $0.killed } ).count
        }
        
        self.score += score()
        
        clean()
    }
}

extension Units {
    
    func add(unit: CKUnit) {
        switch unit {
        case let u as Fish:
            fishes.add(u)
        case let u as Bullet:
            bullets.add(u)
        case let u as Treasure:
            treasures.add(u)
        case let u as Herb:
            herbs.add(u)
        default:
            break
        }
    }
    
    func remove(unit: CKUnit) {
        switch unit {
        case is Fish:
            fishes.remove(unit)
        case is Bullet:
            bullets.remove(unit)
        case is Treasure:
            treasures.remove(unit)
        case is Herb:
            herbs.remove(unit)
        default:
            break
        }
    }
}