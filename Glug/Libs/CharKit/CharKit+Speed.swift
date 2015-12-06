//
//  CharKit+Speed.swift
//  Glug
//
//  Created by piton on 31.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

typealias CKSpeed = CharKit.Speed

extension CharKit {
    
    enum Speed: Int {
        
        case Min = 1
        case Low
        case Medium
        case High
        case Max
        case Zero = 0

        var value: Int {
            let m = 1
            return self.rawValue * m
        }
        
        func check(time: UpdateTime) -> Bool {
            if case .Zero = self {
                return false
            }
            typealias S = Speed
            let min = S.Min.value
            let max = S.Max.value
            let v = max - value + min
            if v > max {
                return false
            }
            return v <= min ? true : (time % v) == 0
        }
        
        func checkSlow(time: UpdateTime) -> Bool {
            return check(time) && (time % (Max.value * 3) == 0)
        }
        
        static func random() -> Speed {
            return random(.Min, .Max)
        }
        
        static func random(min: Speed, _ max: Speed) -> Speed {
            return Speed(rawValue: Int.random(min.rawValue, max.rawValue)) ?? .Medium
        }
    }
}