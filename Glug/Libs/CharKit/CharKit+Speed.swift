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
    
    enum Speed: Double {
        
        case Min = 1
        case Low
        case Medium
        case High = 4.9
        case Max = 5
        case Zero = 0

        static let k = 2.0
        
        init?(value: Int) {
            let val: Double = value == 4 ? High.rawValue : Double(value)
            self.init(rawValue: val)
        }
        
        var value: Double {
            return self.rawValue * Speed.k
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
            return v <= min ? true : (time % Int(v)) == 0
        }
        
        func checkSlow(time: UpdateTime) -> Bool {
            return check(time) && (time % Int(Max.value * 3) == 0)
        }

        static func random() -> Speed {
            return random(.Min, .Max)
        }
        
        static func random(min: Speed, _ max: Speed) -> Speed {
            return Speed(value: Int.random(Int(min.rawValue), Int(max.rawValue))) ?? .Medium
        }
    }
}