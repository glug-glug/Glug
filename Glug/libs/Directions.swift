//
//  Directions.swift
//  Glug
//
//  Created by piton on 05.09.15.
//  Copyright (c) 2015 anukhov. All rights reserved.
//

import Foundation

public enum Directions: String {
    case Right      = "➡️"
    case RightDown  = "↘️"
    case Down       = "⬇️"
    case DownLeft   = "↙️"
    case Left       = "⬅️"
    case LeftUp     = "↖️"
    case Up         = "⬆️"
    case UpRight    = "↗️"
}

extension Directions {
    
    mutating func invert() {
        switch self {
        case .Left:  self = .Right
        case .Right: self = .Left
        case .Up:    self = .Down
        case .Down:  self = .Up
        default:
            break // TODO:
        }
    }
    
    func split() -> (horizontal: Directions?, vertical: Directions?) {
        typealias D = Directions
        switch self {
        case .Right:        return (D.Right, nil)
        case .RightDown:    return (D.Right, D.Down)
        case .Down:         return (nil, D.Down)
        case .DownLeft:     return (D.Left, D.Down)
        case .Left:         return (D.Left, nil)
        case .LeftUp:       return (D.Left, D.Up)
        case .Up:           return (nil, D.Up)
        case .UpRight:      return (D.Right, D.Up)
        }
    }
}

