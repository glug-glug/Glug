//
//  ViewController.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

var hero: CKUnit!

class GameController: CKController {
    
    var rockets: [CKUnit] = []

    func log(text: String) {
        print(text)
    }
    
    override func initializeScene() -> CKScene {
        let scene = super.initializeScene()
        
//        var data: [Character?] = []
//        data += [nil, "👀", nil]
//        data += [nil, "⚪️", nil]
//        data += [nil, "⚪️", nil]

        let arr = [
            "◻️🔴◻️◻️◻️◻️◻️",
            "🔴◻️◻️◻️◻️◻️◻️",
            "🔴◻️◻️◻️◻️◻️🔴",
            "🔴◻️🔴◻️◻️◻️🔴",
            "◻️🔴◻️◻️◻️🔴◻️",
            "◻️◻️🔴🔴🔴◻️◻️",
            "◻️◻️◻️◻️◻️◻️◻️"
        ]
        
        var data: [Character?] = []
        
        for str in arr {
            for ch in str.characters {
                switch ch {
                case "🔴":
                    data += ["🔴" as Character?]
                default:
                    data += [nil]
                }
            }
        }
        
        let speed = 1
        
        let sprite = CKSprite(size: CKSize(7, 6), data: data)
        hero = Hero(sprite: sprite, position: CKPoint(0, 0), speed: speed)
        
//        data = ["⛵️"]
//        let sheepSprite = CKSprite(size: CKSize(1, 1), data: data)
//        let sheep = Sheep(sprite: sheepSprite, position: CKPoint(1, 0), speed: speed)
        
        scene.addUnit(hero)
//        scene.addUnit(sheep)
        
        return scene
    }
    
    func moveHero(direction dir: Directions?) {

    }
    
    func fire() {
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
    }
    
    override func joystickDirectionChanged(direction: Directions?) {
        hero.direction = direction
        log(direction?.rawValue ?? "STOP")
    }
    
    override func joystickFired() {
        fire()
        log("🔴")
    }
    
    override func joystickAngleChanged(angle: Float?) {
        log(angle == nil ? "" : "\(angle!)")
    }
}

class Sheep: CKUnit {
    
    override func update(time: UpdateTime) {
        position = CKPoint(hero.position.x + 1, 0)
    }
}

class Hero: CKUnit {
    
//    var horizontalDirection
    
    override func update(time: UpdateTime) {
        super.update(time)
        
//        var d = dir(direction)
        
//        if let d = d {
//            if d == .Left {
//                
//                var data: [Character?] = []
//                data += [nil, "👀", nil]
//                data += ["👈", "⚪️", nil]
//                data += [nil, "⚪️", nil]
//                
//                sprite = CKSprite(size: CKSize(3, 3), data: data)
//                
//            } else {
//                
//                var data: [Character?] = []
//                data += [nil, "👀", nil]
//                data += [nil, "⚪️", "👉"]
//                data += [nil, "⚪️", nil]
//                
//                sprite = CKSprite(size: CKSize(3, 3), data: data)
//            }
//        }
    }
    
}

func dir(direction: Directions?) -> Directions? {
    
    var d: Directions?
    
    if let direction = direction {
        switch direction {
        case .Right, .RightDown, .UpRight:
            d = .Right
        case .Left, .DownLeft, .LeftUp:
            d = .Left
        default:
            break
        }
    }
    
    return d
}

