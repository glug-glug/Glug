//
//  Level.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import Foundation

class Level {

    let number: Int
    
    var name = ""
    var herbs = 0
    var isComplete = false

    weak var service: LevelsService?
    
    init(dictionary d: [String: AnyObject], number: Int, service: LevelsService?) {
        name  <~ d["name"]
        herbs <~ d["herbs"]
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
}

func == (lhs: Level, rhs: Level) -> Bool {
    return lhs.number == rhs.number
}

extension Level: Equatable {}

