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
        let units = self.createUnits()
        self.scene.addUnits(units.all)
        return units
    }()

    var direction: Directions? {
        didSet {
            units.diver <^> direction
        }
    }
    
    init(scene: CKScene, level: Level) {
        self.level = level
        self.scene = scene
        let _ = units
    }
    
    func remove(unit: CKUnit) {
        switch unit {
        case let unit as Fish:
            remove(unit, &units.fishes)
        case let unit as Treasure:
            remove(unit, &units.treasures)
        default:
            // TODO:
            break
        }
    }
}

extension GameService {
    
    private func createUnits() -> Units {
       
        let size = scene.size
        
        let diver = Diver(center: CKPoint(size / 2))
        let ship = Ship(center: CKPoint(diver.center.x, 0))
        let tube = Tube()
        let sky = Sky(rect: CKRect(origin: CKPoint(0, 0), size: CKSize(size.width, 1)))
        let ground = Ground()
        let herbs = Herb.create(size, density: .Hard) // TODO: density
        
        let units = Units(diver: diver, ship: ship, tube: tube, sky: sky, ground: ground, herbs: herbs)
        return units
    }
}

extension GameService {
    
    private func remove<T: CKUnit>(unit: T, inout _ array: [T]) {
        var j = 0
        for (i, u) in array.enumerate() {
            guard u === unit else {
                continue
            }
            array.removeAtIndex(i + j--)
        }
        unit.remove()
    }
    
    private func add<T: CKUnit>(unit: T, inout _ array: [T]) {
        array.append(unit)
        scene.addUnit(unit)
    }
}



extension GameService {

    func addSolidUnit() {
        
        let s =
        "🔴◻️◻️◻️◻️◻️🔴🔴🔴🔴🔴\n" +
        "◻️🔴◻️◻️◻️◻️◻️◻️◻️◻️◻️\n" +
        "◻️🔴🔴◻️◻️◻️◻️◻️◻️◻️◻️\n" +
        "◻️🔴🔴🔴◻️◻️◻️◻️◻️◻️◻️\n" +
        "🔴◻️◻️🔴🔴◻️◻️◻️◻️◻️◻️\n" +
        "◻️◻️◻️◻️🔴🔴◻️◻️◻️◻️◻️\n" +
        "◻️◻️◻️◻️◻️◻️🔴🔴🔴🔴◻️\n"
        
        let fish = Fish(position: CKPoint(0, 10), direction: .Right, speed: .Zero, sprite: CKSprite(s), solid: true)
        
        scene.addUnit(fish)
        units.add(fish)
    }

    func addRightFish() {
        
        let fish = Fish(position: CKPoint(0, 10), direction: .Right, speed: .Low, sprite: CKSprite("😑"), solid: true)
        
        scene.addUnit(fish)
        units.add(fish)
    }
    
    // TODO: test
    func addFish() {
        
        func p() -> CKPoint {
            let x = Int.random(0, scene.size.width)
            let y = Int.random(0, scene.size.height)
            return CKPoint(x, y)
        }
        
        func d() -> Directions {
            var d: Directions!
            repeat {
                d = Directions(Int.random(0, 7))!
            } while d.horizontal == nil
            return d.horizontal!
//            return Directions(Int.random(0, 7))!
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
        
        func s() -> CKSpeed {
            return CKSpeed.random()
        }
        
        let fish = Fish(center: p(), direction: d(), speed: s(), sprite: CKSprite(f()), solid: true)
        
        scene.addUnit(fish)
        units.add(fish)
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
        
        scene.addUnit(fish)
        units.add(fish)
    }
}