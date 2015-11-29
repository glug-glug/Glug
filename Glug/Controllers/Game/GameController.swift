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
        let service = GameService(scene: self.scene, level: self.level) // set background ?
        service.onGameOver = { [weak self] win in
            self?.gameOver(win)
        }
        return service
    }()
    
    override var color: UIColor {
        return Constants.Colors.background
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = service
    }
    
    override func update(time: UpdateTime) {
        super.update(time)        
        service.update(time)
    }
    
    override func joystickDirectionChanged(direction: Directions?) {
        service.direction = direction        
        log(direction?.rawValue ?? Directions.stop)
    }
    
    override func joystickFired() {
        log("🔴")
        service.fire()
    }
    
    //
    
    func gameOver(win: Bool) {
        
        stop()
        if win {
            level.complete()
        }
        
        GameOverController.show(self, result: .Win) { [weak self] action in
            print(action)
            self?.home()
        }
    }
}

