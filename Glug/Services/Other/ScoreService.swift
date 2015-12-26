//
//  ScoreService.swift
//  Glug
//
//  Created by piton on 21.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

class ScoreService {
    
    let kScore = "Score"
    
    init() {
        score = defaults.objectForKey(kScore) as? Score ?? 0
    }
    
    var score: Score {
        didSet {
            if oldValue >= score {
                return
            }
            defaults.setObject(score, forKey: kScore)
        }
    }
    
    var text: String {
        return score > 0 ? "\(score)" : ""
    }
}

