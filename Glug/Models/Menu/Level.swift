//
//  Level.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import Foundation

class Level {

    struct Fishes {
        
        struct Kind {
            var sprite = "✖️"
            var speed = CKSpeed.Medium
            var shark = false
            
            init(dictionary d: [String: AnyObject]) {
                sprite <~ d["sprite"]
                
                var s = 0
                s <~ d["speed"]
                speed = CKSpeed(rawValue: s) ?? speed
                
                shark  <~ d["shark"]
            }
        }
        
        var kinds = [Kind]()
        var density = 0
        
        init(dictionary d: [String: AnyObject]) {
            
            density <~ d["density"]
            
            var arr = [[String: AnyObject]]()
            arr <~ d["kinds"]
            
            arr.forEach {
                kinds.append(Kind(dictionary: $0))
            }
        }
    }
    
    let number: Int
    
    var name = ""
    var herbs = 0
    var isRun = false
    var fishes: Fishes
    
    var isComplete = false

    weak var service: LevelsService?
    
    init(dictionary d: [String: AnyObject], number: Int, service: LevelsService?) {
        
        name  <~ d["name"]
        herbs <~ d["herbs"]
        isRun <~ d["run"]
        
        var fishes = [String: AnyObject]()
        fishes <~ d["fishes"]

        self.fishes = Fishes(dictionary: fishes)

        self.number = number
        self.service = service
    }

    func complete() {
        isComplete = true
        service?.complete(self)
    }
    
    var locked: Bool {
        return service?.locked(self) ?? true
    }
    
    var next: Level? {
        return service?.next(self)
    }
}

func == (lhs: Level, rhs: Level) -> Bool {
    return lhs.number == rhs.number
}

extension Level: Equatable {}

