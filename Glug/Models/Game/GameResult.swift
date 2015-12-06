//
//  GameResult.swift
//  Glug
//
//  Created by piton on 29.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

enum GameResult: String {

    case Win = "Win"
    case Lose = "Lose"

    var name: String {
        return rawValue
    }
}

