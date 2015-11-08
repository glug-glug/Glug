//
//  Updater.swift
//  Glug
//
//  Created by piton on 18.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

typealias UpdateTime = Int

class Updater: NSObject {
    
    let ti: NSTimeInterval
    
    lazy var delta: Int64 = {
       return Int64(self.ti * Double(NSEC_PER_SEC))
    }()
    
    var active = false {
        didSet {
            if active && !oldValue {
                update()
            }
        }
    }
    
    var onUpdate: ((UpdateTime) -> ())?
    
    var time: UpdateTime = 0 {
        didSet {
            if time > 100 {
                time = 0
            }
        }
    }
    
    func play() {
        active = true
    }

    func stop() {
        active = false
    }
    
    private func update() {
        if !active {
            return
        }
        time++
        onUpdate?(time)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue()) {
            self.update()
        }
    }
    
    init(ti: NSTimeInterval = 0.1, onUpdate: ((UpdateTime) -> ())? = nil) {
        self.ti = ti
        self.onUpdate = onUpdate
    }
    
    deinit {
        stop()
    }
}