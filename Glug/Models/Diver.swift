//
//  Diver.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Diver: CKUnit {
    
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
    
    init() {
        
        let str =
            "👀\n" +
            "⚪️"
        
        let sprite = CKSprite(string: str)
        
        let speed = 1
        
        super.init(sprite: sprite, position: CKPoint(0, 0), speed: speed)
    }
}

extension CKSprite {


}


//func dir(direction: Directions?) -> Directions? {
//
//    var d: Directions?
//
//    if let direction = direction {
//        switch direction {
//        case .Right, .RightDown, .UpRight:
//            d = .Right
//        case .Left, .DownLeft, .LeftUp:
//            d = .Left
//        default:
//            break
//        }
//    }
//
//    return d
//}

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