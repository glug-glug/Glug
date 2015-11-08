//
//  GameService.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

protocol HitProtocol {
    func hit()
}

extension HitProtocol {
    func hit() {
        (self as? CKUnit)?.remove()
    }
}

class GameService {

    var scene: CKScene
    var level: Level
    
    lazy var units: Units = {        
        let units = self.createUnits()
        self.scene.addUnits(units.all)
        return units
    }()

    var direction: Directions? {
        didSet {
            units.diver <^> direction
        }
    }
    
    func add(unit: CKUnit) {
        units.add(unit)
        scene.addUnit(unit)
    }
    
    func remove(unit: CKUnit) {
        units.remove(unit)
        unit.remove()
    }
    
    func fire() {
        if let bullet = units.diver.fire() {
            add(bullet)
        }
    }
    
    init(scene: CKScene, level: Level) {
        self.level = level
        self.scene = scene
        _ = units
    }
}

extension GameService: Updateble {
   
    func update(time: UpdateTime) {

//        if time % 10 == 0 {
//            fire()
//        }
        
        // TODO: test
        if time == 1 || time % 100 == 0 {
            addFish()
        }

        units.update(time)
        
        if units.missionComplete {
            print("Mission COMPLETE!")
        }
        
        if units.missionFailed {
            print("Mission FAILED!")
        }
    }
}

//extension GameService: BulletHitProtocol {
//    
//    func bulletHit(bullet: Bullet, targets: [CKUnit]) {
//        if targets.isEmpty {
//            return
//        }
//        
//        print("hit: \(targets)")
//    }
//}

extension GameService {
    
    private func createUnits() -> Units {
       
        let size = scene.size
        
        let diver = Diver(center: CKPoint(size / 2))
        let ship = Ship(center: CKPoint(diver.center.x, 0))
        let tube = Tube()
        let sky = Sky(rect: CKRect(origin: CKPoint(0, 0), size: CKSize(size.width, 1)))
        let ground = Ground()
        let treasures = Treasure.create(size)
        let herbs = Herb.create(size, count: level.herbs, exclude: treasures.map { $0.position.x }) // TODO: density
        
        let units = Units(
            diver: diver,
            ship: ship,
            tube: tube,
            sky: sky,
            ground: ground,
            herbs: herbs,
            treasures: treasures
        )
        
        return units
    }
}

// TODO: test, remove 

extension GameService {

    func addSolidUnit() {
        
        let s =
        "🔴◻️◻️◻️◻️◻️🔴🔴🔴🔴🔴\n" +
        "◻️🔴◻️◻️◻️🔴◻️◻️◻️◻️◻️\n" +
        "◻️◻️◻️◻️◻️🔴◻️◻️◻️◻️◻️\n" +
        "◻️◻️◻️◻️◻️🔴◻️◻️◻️◻️◻️\n" +
        "🔴◻️◻️◻️◻️◻️◻️◻️◻️◻️◻️\n" +
        "◻️◻️◻️◻️◻️🔴◻️◻️◻️◻️◻️\n" +
        "◻️◻️◻️◻️◻️🔴🔴🔴🔴🔴◻️\n"
        
        let fish = Fish(position: CKPoint(0, 0), direction: .Right, speed: .Zero, sprite: CKSprite(s), solid: true)
        
        add(fish)
    }

    func addRightFish() {
        
        let fish = Fish(position: CKPoint(0, 10), direction: .Right, speed: .Low, sprite: CKSprite("😑"), solid: true)
        add(fish)
    }
    
    // TODO: test
    func addFish() {
        
        func p() -> CKPoint {
//            let x = Int.random(0, 1) == 0 ? 0 : scene.size.width - 1
            let x = scene.size.width - 1
            let y = Int.random(0 + 1, scene.size.height - 1)
            return CKPoint(x, y)
        }
        
        func d(p: CKPoint) -> Directions {
            return p.x > 0 ? .Left : .Right
            //            var d: Directions!
//            repeat {
//                d = Directions(Int.random(0, 7))!
//            } while d.horizontal == nil
//            return d.horizontal!
//            return Directions(Int.random(0, 7))!
        }
        
        func f() -> String {
            
            switch Int.random(0, 12) {
//            case 0: return "🐍"
            case 1: return "🐟"
            case 2: return "🐠"
//            case 3: return "🐝"
            case 4: return "🐡"
            case 5: return "🐬"
            case 6: return "🐳"
//            case 7: return "🐋"
//            case 8: return "🐊"
//            case 9: return "🐛"
//            case 10: return "🦀"
//            case 11: return "🕷"
            default:
                return "🐟"
            }
        }
        
        func s() -> CKSpeed {
//            return .Min
            return CKSpeed.random()
        }
        
        let center = p()
        
        let fish = Fish(center: center, direction: d(center), speed: s(), sprite: CKSprite(f()))
        
        add(fish)
    }
    
    func addBigFish() {
        
        let s =
        "🔴◻️◻️◻️🔴🔴🔴🔴🔴◻️◻️\n" +
        "◻️🔴◻️🔴🔴🔴🔴🔴⚪️🔴◻️\n" +
        "◻️🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴\n" +
        "◻️🔴🔴🔴🔴🔴🔴🔴🔴🔴🔴\n" +
        "🔴◻️◻️🔴🔴🔴🔴🔴◻️🔴🔴\n" +
        "◻️◻️◻️◻️🔴🔴🔴🔴◻️◻️◻️\n" +
        "◻️◻️◻️◻️◻️◻️🔴🔴🔴🔴◻️\n"
        
        let fish = Fish(position: CKPoint(0, 3), direction: .Right, speed: CKSpeed.Max, sprite: CKSprite(s), canOut: true)
        
        add(fish)
    }
}

extension GameService {
    
    // TODO: add background color to CKUnit; move logic to CharKit
    func render(val: CKRenderString) -> CKRenderString {

        let c = UIColor(hex: 0x00B8D9)
        
        val.addAttributes([
            NSBackgroundColorAttributeName: c
            ], range: NSMakeRange(0, scene.size.width + 1 + 1))
        
        return val
    }
    
}