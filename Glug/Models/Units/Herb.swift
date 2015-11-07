//
//  Herb.swift
//  Glug
//
//  Created by piton on 04.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Herb: CKUnit {
    
    static let data = ("🍁", "🌵")
    
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
            let data = Array(count: height, repeatedValue: Herb.data.1)            
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
        sprite.data[0] = Character(Herb.data.0)
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
    
    static func create(area: CKSize, count: Int, exclude: [Int] = []) -> [Herb]? {
        
        if count < 1 {
            return nil
        }
        
        let xPoints = Int.random(0, area.width - 1, count: count, exclude: exclude)
        let y = area.height - 1
        
        var roots = [CKPoint]()
        
        for x in xPoints {
            roots.append(CKPoint(x, y))
        }        

        func h() -> Int {
            return Int.random(2, area.height / 2)
        }
        
        return roots.map {
            Herb(root: $0, from: 1, to: h())
        }
    }
}
