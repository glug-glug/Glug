//
//  GameService.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

protocol HitProtocol {
    func hit()
}

extension HitProtocol {
    func hit() {
        (self as? CKUnit)?.remove()
    }
}

class GameService {

    var scene: CKScene
    
    var level: Level {
        didSet {
            scene.clear()
            units = nil
            _ = units
        }
    }
    
    var onGameOver: ((GameResult) -> ())?
    
    lazy var units: Units! = {
        let units = self.createUnits()
        self.scene.addUnits(units.all)
        return units
    }()

    var direction: Directions? {
        didSet {
            units.diver <^> direction
        }
    }
    
    func add(unit: CKUnit) {
        units.add(unit)
        scene.addUnit(unit)
    }
    
    func remove(unit: CKUnit) {
        units.remove(unit)
        unit.remove()
    }
    
    func fire() {
        if let bullet = units.diver.fire() {
            add(bullet)
        }
    }
    
    init(scene: CKScene, level: Level) {
        self.scene = scene
        self.level = level
        _ = { self.level = level }()
    }
}

extension GameService: Updateble {
   
    func update(time: UpdateTime) {

        if time % 5 == 0 {
            addFishes()
        }

        units.update(time)

//        if units.missionFailed {
//            onGameOver?(.Lose)
//            return
//        }
        
        if units.missionComplete {
            onGameOver?(.Win)
            return
        }
    }
}

extension GameService {
    
    private func createUnits() -> Units {
       
        let size = scene.size
        
        let diver = Diver(center: CKPoint(size / 2))
        let ship = Ship(center: CKPoint(diver.center.x, 0))
        let tube = Tube()
        let sky = Sky(rect: CKRect(origin: CKPoint(0, 0), size: CKSize(size.width, 1)))
        let treasures = Treasure.create(size)
        let herbs = Herb.create(size, count: level.herbs, exclude: treasures.map { $0.position.x }) // TODO: density
        
        let units = Units(
            diver: diver,
            ship: ship,
            tube: tube,
            sky: sky,
            herbs: herbs,
            treasures: treasures
        )
        
        return units
    }
}

extension GameService {

    func addFishes() {
        
        let fishes = level.fishes
        
        var dif = fishes.density - units.fishes.count
        dif = Int.random(0, dif)
        
        if dif <= 0 {
            return
        }
        
        let centers = Int.random(1, scene.size.height - 1, count: dif)
        
        func center(i: Int) -> CKPoint? {
            let x = scene.size.width - 1
            return 0..<centers.count ~= i ? CKPoint(x, centers[i]) : nil
        }
        
        func fish() -> (CKSprite, CKSpeed, Bool)? {
            let kinds = fishes.kinds
            let i = Int.random(0, kinds.count - 1)
            if 0..<kinds.count ~= i {
                let k = kinds[i]
                return (CKSprite(k.sprite), k.speed, k.shark)
            } else {
                return nil
            }
        }
        
        for i in 0..<dif {
            guard let fish = fish(), center = center(i) else {
                continue
            }
            add(Fish(sprite: fish.0, center, fish.1, shark: fish.2))
        }
    }
}
