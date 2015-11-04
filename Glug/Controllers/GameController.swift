//
//  ViewController.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

// TODO: delegate render for custom bg color ??

class GameController: CKController {
    
    var level: Level!

    lazy var service: GameService = {
        return GameService(scene: self.scene, level: self.level) // set background ?
    }()
    
    override var color: UIColor {
        return Constants.Colors.background
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = service
    }
    
    override func update(time: UpdateTime) {
        super.update(time)
        
        // TODO: test
        if time == 1 || time % 100 == 0 {
            service.addFish()
        }
        
//        if time % 200 == 0 {
//            service.addBigFish()
//        }
    }
    
    override func joystickDirectionChanged(direction: Directions?) {
        service.direction = direction
        
        log(direction?.rawValue ?? Directions.stop)
    }
    
    override func joystickFired() {
        log("🔴")
        service.units.fishes.forEach {
            service.remove($0)
        }
    }
    
    override func render(val: CKRenderString) -> CKRenderString {
        return service.render(val)
    }
}

