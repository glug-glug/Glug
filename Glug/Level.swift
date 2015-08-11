//
//  Level.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import Foundation

protocol LevelProtocol {
    
    var count: Int { get set }
    
    subscript (number: Int) -> Level? { get set }
    
    func level(number: Int) -> Level?
    func next(level: Level) -> Level?
    func complete(level: Level)
    
}

class Level {
    
    
    
}
