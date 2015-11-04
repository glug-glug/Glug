//
//  Herb.swift
//  Glug
//
//  Created by piton on 04.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Herb: CKUnit {
    
    enum Density: Int {
        case Easy   = 1
        case Normal = 2
        case Hard   = 3
        case Zero   = 0
    }
    
    private let root: CKPoint
    private let to: Int
    
    private var ready = false {
        didSet {
            if ready {
                bloom()
            }
        }
    }
    
    private var height = 0 {
        didSet {
            let ch = "🌵"
            let data = Array(count: height, repeatedValue: ch)
            
            sprite = CKSprite(data)
            position = root - CKPoint(0, height > 1 ? height - 1 : 0)
            
            if height >= to {
                ready = true
            }
        }
    }
    
    private func bloom() {
        guard sprite.data.count > 0 else {
            return
        }
        let ch: Character = "🍁"
        sprite.data[0] = ch
    }
    
    override func update(time: UpdateTime) {
        super.update(time)
        
        if ready {
            return
        }
        
        if speed.checkSlow(time) {
            height++
        }
    }
    
    init(root: CKPoint, from: Int = 0, to: Int) {

        self.root = root
        self.to = to
        
        super.init(
            speed: CKSpeed.random(),
            solid: true
        )
        
        let _ = { self.height = from }()
    }
    
    static func create(size: CKSize, density: Density = .Normal) -> [Herb]? {
        
        if density == .Zero {
            return nil
        }
        
        var s: CKSize

        do {
            let h = size.height / 2
            let r = CKRect(origin: CKPoint(0, size.height - h), size: CKSize(size.width, h))
            s = r.size
        }
        
        var roots = [CKPoint]()
        
        do {
            func x() -> Int {
                var (x, cnt) = (0, 0)
                repeat {
                    x = Int.random(0, s.width - 1)
                } while roots.filter( { $0.x == x } ).first != nil && cnt++ < 10
                return x
            }
            let y = size.height - 1
            for _ in 0..<density.rawValue {
                roots.append(CKPoint(x(), y))
            }
        }

        func h() -> Int {
            return Int.random(2, s.height)
        }
        
        return roots.map {
            Herb(root: $0, from: 1, to: h())
        }
    }
}
