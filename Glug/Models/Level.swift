//
//  Level.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import Foundation

typealias Levels = [Level]

class Level {
    
    var name: String!
    var number: Int!
    var isComplete: Bool = false
    
    init(dictionary d: [String: AnyObject]) {
        name   <! d["name"]
        number <! d["number"]
    }

    func complete() {
        isComplete = true
        LevelsService().complete(self)
    }
}
