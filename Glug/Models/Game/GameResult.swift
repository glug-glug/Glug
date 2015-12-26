//
//  GameResult.swift
//  Glug
//
//  Created by piton on 29.11.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

enum GameResult {

    case Win(Score)
    case Lose(Score)

    var name: String {
        if case Win = self {
            return "Win"
        } else {
            return "Lose"
        }
    }
    
    var score: Score {
        switch self {
        case .Win(let score):
            return score
        case .Lose(let score):
            return score
        }
    }
}

