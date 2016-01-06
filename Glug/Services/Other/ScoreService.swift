//
//  ScoreService.swift
//  Glug
//
//  Created by piton on 21.12.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

typealias Score = Int

class ScoreService {
    
    let kScore = "Score"
    
    init() {
        score = defaults.objectForKey(kScore) as? Score ?? 0
    }
    
    lazy var gcService = {
       return GCService()
    }()
    
    var score: Score {
        didSet {
            if score > oldValue {
                defaults.setObject(score, forKey: kScore)
                gcService.reportScore(score)
            } else {
                score = oldValue
            }
        }
    }
}

