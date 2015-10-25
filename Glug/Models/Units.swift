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
    var ship: Ship?
    var tube: Tube?
    var fishes: [Fish]?
    var treasures: [Treasure]?
    
    var all: [CKUnit] {
        return [diver] //+ fishes + treasures
    }
    
//    var background:
//    var units: [CKUnit] = []
    
    init(diver: Diver, ship: Ship, tube: Tube, fishes: [Fish] = [], treasures: [Treasure]) {
        self.diver = diver
        self.ship = ship
        self.tube = tube
        self.fishes = fishes
        self.treasures = treasures
    }

    init(diver: Diver) {
        self.diver = diver
    }
}