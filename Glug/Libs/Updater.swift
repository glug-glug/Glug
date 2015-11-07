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
    
    var onUpdate: ((UpdateTime) -> ())?
    
    private var timer: NSTimer? {
        willSet{
            stop()
        }
        didSet {
            timer?.fire()
        }
    }
    
    var time: UpdateTime = 0
    
    func reset() {
        time = 0
    }
    
    func play() {
        timer = NSTimer.scheduledTimerWithTimeInterval(ti, target: self, selector: "update", userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
    }
    
    func update() {
        time++
        onUpdate?(time)
    }
    
    init(ti: NSTimeInterval = 0.1, onUpdate: ((UpdateTime) -> ())? = nil) {
        self.ti = ti
        self.onUpdate = onUpdate
    }
    
    deinit {
        stop()
    }
}