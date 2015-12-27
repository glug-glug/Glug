//
//  GameActions.swift
//  Glug
//
//  Created by piton on 29.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

enum GameActions: String {

    case Next = "Next"
    case Replay = "Replay"
    
    var name: String {
        return rawValue
    }
}
