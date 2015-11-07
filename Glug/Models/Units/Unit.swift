//
//  Unit.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

protocol PositionedUnit {
    
    var defaultPosition: CKPoint { get }
}

extension PositionedUnit {
    
    var defaultPosition: CKPoint {
        return CKPoint.zeroPoint
    }
}