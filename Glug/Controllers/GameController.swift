//
//  ViewController.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

class GameController: CKController {
    
    var level: Level!

    lazy var serice: GameService = {
        return GameService(scene: self.scene, level: self.level) // set background ?
    }()
    
    override var color: UIColor {
        return Constants.Colors.background
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = serice
    }
    
    override func update(time: UpdateTime) {
        super.update(time)
        
        // TODO: test
        //        if time % 1 == 0 {
            serice.addFish()
        //        }
    }
    
    override func joystickDirectionChanged(direction: Directions?) {
        serice.direction = direction
        
        log(direction?.rawValue ?? Directions.stop)
    }
    
    override func joystickFired() {
        log("🔴")
    }
}

