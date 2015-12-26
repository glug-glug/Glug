//
//  ViewController.swift
//  Glug
//
//  Created by piton on 23.08.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import UIKit

class GameController: CKController {
    
    lazy var service: GameService = {
        let service = GameService(scene: self.scene, level: self.level)
        service.onGameOver = { [weak self] result in
            self?.gameOver(result)
        }
        service.onScore = { [weak self] score in
            self?.score = score
        }
        return service
    }()

    var level: Level! {
        didSet {
            if !isViewLoaded() {
                return
            }
            service.level = level
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bgColor = Constants.Colors.background
    }
    
    override func customize() {
        service.addSurface(gameView)
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
    
    override func start() {
        _ = service
//        backgroundImage = "bg"
        forceRender()
        score = 0
        LevelIntroController.show(self, level: level) {
            super.start()
        }
    }
    
    func gameOver(result: GameResult) {

        stop()
        
        var actions: [GameActions] = []
        
        if case .Win = result {
            level.complete()
            actions.append(level.next == nil ? .Replay : .Next)
        } else {
            actions.append(.Replay)
        }

        GameOverController.show(self, result: result, actions: actions) { action in
            if case .Next = action {
                self.level = self.level.next ?? self.level
            } else {
                self.level = { self.level }()
            }
            self.start()
        }
    }
}





