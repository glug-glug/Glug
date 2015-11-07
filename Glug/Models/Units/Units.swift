//
//  Units.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class Units {

    var diver: Diver
    var ship: Ship
    var tube: Tube
    var sky: Sky
    var ground: Ground?
    var herbs: [Herb]?
    var fishes: [Fish] = []
    var treasures: [Treasure] = []
    
    var all: [CKUnit] {
        var all: [CKUnit] = [diver, ship, tube, sky] + fishes
        all += treasures as [CKUnit]
        all += ground == nil ? [] : [ground!]
        all += (herbs ?? []) as [CKUnit]
        return all
    }
    
//    var background:

    func add(fish: Fish) {
        fishes.append(fish)
    }
    
    init(diver: Diver,
        ship: Ship,
        tube: Tube,
        sky: Sky,
        ground: Ground?,
        herbs: [Herb]? = nil,
        fishes: [Fish] = [],
        treasures: [Treasure] = []) {
            
            self.diver = diver
            self.ship = ship
            self.tube = tube
            self.sky = sky
            self.ground = ground
            self.herbs = herbs
            self.fishes = fishes
            self.treasures = treasures
            
            ship.diver = diver
            tube.ship = ship
            tube.diver = diver
    }
}