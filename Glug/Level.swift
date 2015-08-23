//
//  Level.swift
//  Glug
//
//  Created by Александр on 11.08.15.
//  Copyright (c) 2015 iOSDevCourse. All rights reserved.
//

import Foundation

class Level {
    
    var name: String!
    var number: Int!
    var isComplete: Bool!
    
    init(dictionary: NSDictionary) {
        
        name = dictionary.objectForKey("Name") as! String
        number = dictionary.objectForKey("Number") as! Int
        isComplete = dictionary.objectForKey("isComplete") as! Bool
        
    }
    
}
