//
//  Treasure.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Treasure: CKUnit {
    
    enum Kinds {
        case Custom(Character)
        
        static let count = 3
//        static let data = "👑🍉🍟🍺🏆🎺📱🕌💰🎁👙🎂🍹🍷🍦🔱"
        static let data = "👑🍉🍟🎺📱💰👙🍷🍦"
        
        var value: Character {
            switch self {
            case .Custom(let ch):
                return ch
            }
        }

        static var set: [Kinds] {
            let s = Array(data.characters)
            func v(i: Int) -> Kinds {
                return Custom(0..<s.count ~= i ? s[i] : s.first!)
            }
            return Int.random(0, s.count - 1, count: count).map {
                v($0)
            }
        }
    }
    
    let kind: Kinds
    let origin: CKPoint
    
    override func update(time: UpdateTime) {
        super.update(time)
    }
    
    init(position: CKPoint, kind: Kinds) {
        
        self.kind = kind
        origin = position
        
        super.init(
            position: position,
            sprite: CKSprite(kind.value),
            solid: true
        )
    }
    
    static func create(area: CKSize) -> [Treasure] {
        
        let kinds = Kinds.set
        
        let xPoints = Int.random(0, area.width - 1, count: kinds.count)
        let y = area.height - 1
        
        func x(i: Int) -> Int {
            return 0..<xPoints.count ~= i ? xPoints[i] : 0
        }

        return kinds.reduce([Treasure]()) {
            return $0 + [Treasure(position: CKPoint(x($0.count), y), kind: $1)]
        }
    }
    
}
