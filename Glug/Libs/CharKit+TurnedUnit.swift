//
//  CharKit+TurnedUnit.swift
//  Glug
//
//  Created by piton on 25.10.15.
//  Copyright © 2015 anukhov. All rights reserved.
//

import Foundation

typealias CKTurnedUnit = CharKit.TurnedUnit

extension CharKit {
    
    class TurnedUnit: CKUnit {
        
        var turnChanged: ((Directions) -> ())?
        
        override var direction: Directions? {
            didSet {
                saveTurn(direction)
            }
        }
        
        var turn: (horizontal: Directions?, vertical: Directions?)
        
        func saveTurn(direction: Directions?) {
            
            guard let dir = direction?.split() else {
                return
            }
            
            if let direction = dir.horizontal {
                if direction != turn.horizontal {
                    turnChanged?(direction)
                }
                turn.horizontal = direction
            }
            
            if let direction = dir.vertical {
                if direction != turn.vertical {
                    turnChanged?(direction)
                }
                turn.vertical = direction
            }
        }
    }
}

