//
//  GameService.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class GameService {

    var scene: CKScene
    var level: Level
    
    lazy var units: Units = {        
        return Units.create(self.level, scene: self.scene)
    }()

    var direction: Directions? {
        didSet {
            units.diver <^> direction
        }
    }
    
    init(scene: CKScene, level: Level) {
        self.level = level
        self.scene = scene
        scene.addUnits(units.all)
    }
}

extension Units {
    
    static func create(level: Level, scene: CKScene) -> Units {
        
        let diver = Diver(center: CKPoint(scene.size / 2))
        let ship = Ship(center: CKPoint(diver.center.x, 0))
        let tube = Tube()        
        
        let units = Units(diver: diver, ship: ship, tube: tube)
        return units
    }
}

extension GameService {
    
    // TODO: test
    func addFish() {
        
        func p() -> CKPoint {
            let x = Int.random(0, scene.size.width)
            let y = Int.random(0, scene.size.height)
            return CKPoint(x, y)
        }
        
        func d() -> Directions {
            //            var d: Directions!
            //            repeat {
            //                d = Directions(Int.random(0, 7))!
            //            } while d.horizontal == nil
            //            return d.horizontal!
            return Directions(Int.random(0, 7))!
        }
        
        func f() -> String {
            
            switch Int.random(0, 12) {
            case 0: return "🐍"
            case 1: return "🐟"
            case 2: return "🐠"
            case 3: return "🐝"
            case 4: return "🐡"
            case 5: return "🐬"
            case 6: return "🐳"
            case 7: return "🐋"
            case 8: return "🐊"
            case 9: return "🐛"
            case 10: return "🦀"
            case 11: return "🕷"
            default:
                return "🐸"
            }
        }
        
        func s() -> Int {
            return Int.random(1, 3)
        }
        
        scene.addUnit(Fish(center: p(), direction: d(), speed: s(), sprite: CKSprite(f())))
    }
}