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
        
        private static let data = "👑🍟🎺📱💰👙🍷🍦"        
        private static var dataCount: Int {
            return Array(data.characters).count
        }
        
        var value: Character {
            switch self {
            case .Custom(let ch):
                return ch
            }
        }

        init(_ idx: Int) {
            let s = Array(Kinds.data.characters)
            self = Custom(0..<s.count ~= idx ? s[idx] : s.first!)
        }
        
        static var set: [Kinds] {
            return Int.random(0, dataCount - 1, count: count).map {
                Kinds($0)
            }
        }
        
        static func random() -> Kinds {
            return Kinds(Int.random(0, dataCount - 1))
        }
    }
    
    let kind: Kinds

    var delivered = false {
        didSet {
            if delivered {
                remove()
            }
        }
    }
    
    init(position: CKPoint, kind: Kinds) {
        
        self.kind = kind
        
        super.init(
            position: position,
            sprite: CKSprite(kind.value)
        )
        
        zPosition = 1
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
    
    func deliver() {
        delivered = true
    }    
}
