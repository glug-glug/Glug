//
//  GameService.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class GameService {

    var scene: CKScene
    var level: Level
    
    lazy var units: Units = {
        let diver =  Diver()
        let units = Units(diver: diver)
        return units
    }()

    var direction: Directions? {
        didSet {
            units.diver <^> direction
        }
    }
    
    init(scene: CKScene, level: Level) {
        self.level = level
        self.scene = scene
        scene.addUnits(units.all)
    }    
}