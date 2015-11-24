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
    
    lazy var queue = {
        return dispatch_queue_create("updater.queue", DISPATCH_QUEUE_SERIAL)
    }()
    
    private func update() {

        let act = {
            if !self.active {
                return
            }
            self.time++
            self.onUpdate?(self.time)
        }
        
        dispatch_async(queue) {
            act()
            if !self.active {
                return
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, self.delta), self.queue) {
                self.update()
            }
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