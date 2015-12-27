//
//  GameService.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import UIKit

class GameService: AudioService {

    var scene: CKScene
    
    var level: Level {
        didSet {
            scene.clear()
            units = nil
            _ = units
        }
    }
    
    var onGameOver: ((GameResult) -> ())?
    
    var onScore: ((Score) -> ())?
    
    lazy var units: Units! = {
        
        let units = self.createUnits()
        self.scene.addUnits(units.all)
        
        units.onScore = { [weak self] score in
            self?.scoreService.score = score
            self?.onScore?(score)
        }
        
        return units
    }()

    lazy var scoreService: ScoreService = {
        return ScoreService()
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
            play(.Fire)
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

        if CKSpeed.Min.checkSlow(time) {
            addFishes()
            run(time)
        }
        
        units.update(time)

        if units.missionFailed {
            onGameOver?(.Lose(units.score))
            play(.Lose)
            return
        }
        
        if units.missionComplete {
            onGameOver?(.Win(units.score))
            play(.Win)
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
        
        var treasures: [Treasure]?
        var herbs: [Herb]?
        
        if !level.isRun {
            treasures = Treasure.create(size)
            herbs = Herb.create(size, count: level.herbs, exclude: treasures?.map { $0.position.x } ?? [])
        }
        
        let units = Units(
            level: level,
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

    private func addFishes() {
        
        let fishes = level.fishes
        
        var dif = fishes.density - units.fishes.count
        dif = Int.random(0, dif)
        
        if dif <= 0 {
            return
        }
        
        let positions = Int.random(1, scene.size.height - 1, count: dif)
        
        func fish(i: Int) -> (CKSprite, CKPoint, CKSpeed, Directions, shark: Bool)? {
            
            func p(i: Int, shark: Bool) -> CKPoint? {
                let x = shark ? 0 : scene.size.width - 1
                return 0..<positions.count ~= i ? CKPoint(x, positions[i]) : nil
            }
            
            let kinds = fishes.kinds
            let j = Int.random(0, kinds.count - 1)
            guard 0..<kinds.count ~= j  else {
                return nil
            }
            let k = kinds[j]
            
            guard var pos = p(i, shark: k.shark) else {
                return nil
            }
            
            let dir: Directions = k.shark ? .Right : .Left
            let sprite = CKSprite(k.sprite, separator: ",")

            if k.shark {
                pos.x -= sprite.size.width
            }
            
            return (sprite, pos, k.speed, dir, k.shark)
        }

        for i in 0..<dif {
            guard let fish = fish(i) else {
                continue
            }
            if fish.shark && Int.random(0, 100) > 20 {
                continue
            }
            add(Fish(fish.0, fish.1, fish.2, fish.3, fish.4))
        }
    }
    
    private func addTreasure() {
        
        var dif = (level.run?.treasuresDensity ?? 0) - units.treasures.filter( { !$0.delivered } ).count
        dif = Int.random(0, dif)
        
        if dif <= 0 {
            return
        }
        
        func p() -> CKPoint {
            return CKPoint(scene.size.width - 1, scene.size.height - 1)
        }
        
        let treasure = Treasure(position: p(), kind: Treasure.Kinds.random())
        treasure.direction = .Left
        treasure.speed = .Min
        treasure.canOut = true
        
        add(treasure)
    }

    private func addHerb() {
        
        let density = (level.run?.herbsDensity ?? 0) 
        var dif = density - (units.herbs.count ?? 0)
        dif = Int.random(0, dif)
        
        if dif <= 0 {
            return
        }
        
        let p = CKPoint(scene.size.width - 1, scene.size.height - 1)
        
        if !units.treasures.filter( { $0.position == p } ).isEmpty {
           return
        }
        
        let h = Int.random(2, scene.size.height / 2)
        
        let herb = Herb(root: p, from: h, to: h)
        herb.direction = .Left
        herb.speed = .Min
        herb.canOut = true
        herb.solid = true
        
        add(herb)
    }
    
    private func run(time: UpdateTime) {
        if !level.isRun {
            return
        }
        addTreasure()
        addHerb()
    }
}

import SpriteKit

extension GameService {
    
    func addSurface(gameView: CKGLView) {
        guard let glScene = gameView.glScene, f = glScene.labels.first?.frame else {
            return
        }
        let color = UIColor(hex: 0xffffff, alpha: 0.4)
        let l = SKSpriteNode(color: color, size: CGSizeMake(glScene.frame.width, 1))
        l.anchorPoint = CGPointMake(0, 0)
        l.position = CGPointMake(0, f.origin.y)
        glScene.addChild(l)
        gameView.forceRender()
    }
}


